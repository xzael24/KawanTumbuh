import {
  BadRequestException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { IsNull, Repository } from 'typeorm';
import {
  randomNumericCode,
  randomToken,
  sha256,
  verifyPassword,
} from '../common/crypto.util.js';
import { CreateUserDto } from '../users/dto/create-user.dto.js';
import { User } from '../users/entities/user.entity.js';
import { PublicUser, UsersService } from '../users/users.service.js';
import { ForgotPasswordDto } from './dto/forgot-password.dto.js';
import { LoginDto } from './dto/login.dto.js';
import { LogoutDto } from './dto/logout.dto.js';
import { RefreshTokenDto } from './dto/refresh-token.dto.js';
import { ResetPasswordDto } from './dto/reset-password.dto.js';
import { SocialLoginDto } from './dto/social-login.dto.js';
import { VerifyResetCodeDto } from './dto/verify-reset-code.dto.js';
import { PasswordResetCode } from './entities/password-reset-code.entity.js';
import { RefreshToken } from './entities/refresh-token.entity.js';
import { SocialAccount } from './entities/social-account.entity.js';
import { JwtService } from './jwt.service.js';

const REFRESH_TOKEN_TTL_MS = 30 * 24 * 60 * 60 * 1000; // 30 hari
const RESET_CODE_TTL_MS = 10 * 60 * 1000; // 10 menit
const RESET_CODE_MAX_ATTEMPTS = 5;

export interface SessionResult {
  user: PublicUser;
  tokenType: 'Bearer';
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

export interface SessionInfo {
  id: string;
  userAgent: string | null;
  createdAt: Date;
  expiresAt: Date;
  revokedAt: Date | null;
}

export interface SocialAccountInfo {
  id: string;
  provider: string;
  providerUserId: string;
  createdAt: Date;
}

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService,
    @InjectRepository(RefreshToken)
    private readonly refreshTokensRepository: Repository<RefreshToken>,
    @InjectRepository(SocialAccount)
    private readonly socialAccountsRepository: Repository<SocialAccount>,
    @InjectRepository(PasswordResetCode)
    private readonly resetCodesRepository: Repository<PasswordResetCode>,
  ) {}

  async register(dto: CreateUserDto): Promise<SessionResult> {
    const user = await this.usersService.create(dto);
    return this.issueSession(user);
  }

  async login(dto: LoginDto, userAgent?: string): Promise<SessionResult> {
    const user = await this.usersService.findByEmail(dto.email);

    if (!user || !verifyPassword(dto.password, user.password)) {
      throw new UnauthorizedException('Email atau password salah');
    }

    return this.issueSession(user, userAgent);
  }

  async refresh(dto: RefreshTokenDto, userAgent?: string): Promise<SessionResult> {
    const tokenHash = sha256(dto.refreshToken);
    const stored = await this.refreshTokensRepository.findOne({
      where: { tokenHash },
    });

    if (!stored) {
      throw new UnauthorizedException('Refresh token tidak valid');
    }

    if (stored.revokedAt) {
      // Token lama dipakai ulang -> indikasi token bocor, cabut semua sesi user.
      await this.revokeAll(stored.userId);
      throw new UnauthorizedException('Refresh token sudah digunakan, silakan login ulang');
    }

    if (stored.expiresAt.getTime() <= Date.now()) {
      stored.revokedAt = new Date();
      await this.refreshTokensRepository.save(stored);
      throw new UnauthorizedException('Refresh token sudah kedaluwarsa, silakan login ulang');
    }

    stored.revokedAt = new Date();
    await this.refreshTokensRepository.save(stored);

    const user = await this.usersService.findById(stored.userId);
    return this.issueSession(user, userAgent);
  }

  async logout(dto: LogoutDto): Promise<{ success: boolean; message: string }> {
    await this.refreshTokensRepository.update(
      { tokenHash: sha256(dto.refreshToken), revokedAt: IsNull() },
      { revokedAt: new Date() },
    );

    return { success: true, message: 'Berhasil logout' };
  }

  async logoutAll(userId: string): Promise<{ success: boolean; revokedSessions: number }> {
    const result = await this.refreshTokensRepository.update(
      { userId, revokedAt: IsNull() },
      { revokedAt: new Date() },
    );

    return { success: true, revokedSessions: result.affected ?? 0 };
  }

  async listSessions(userId: string): Promise<SessionInfo[]> {
    const sessions = await this.refreshTokensRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });

    return sessions.map((session) => ({
      id: session.id,
      userAgent: session.userAgent,
      createdAt: session.createdAt,
      expiresAt: session.expiresAt,
      revokedAt: session.revokedAt,
    }));
  }

  async revokeSession(userId: string, sessionId: string): Promise<{ success: boolean }> {
    const session = await this.refreshTokensRepository.findOne({
      where: { id: sessionId, userId },
    });

    if (!session) {
      throw new NotFoundException('Sesi tidak ditemukan');
    }

    if (!session.revokedAt) {
      session.revokedAt = new Date();
      await this.refreshTokensRepository.save(session);
    }

    return { success: true };
  }

  async socialLogin(dto: SocialLoginDto, userAgent?: string): Promise<SessionResult> {
    let account = await this.socialAccountsRepository.findOne({
      where: {
        provider: dto.provider,
        providerUserId: dto.providerUserId,
      },
    });

    if (account) {
      const user = await this.usersService.findById(account.userId);
      return this.issueSession(user, userAgent);
    }

    if (!dto.email) {
      throw new BadRequestException(
        'Email wajib dikirim saat akun sosial belum pernah ditautkan',
      );
    }

    const email = dto.email.trim().toLowerCase();
    let user = await this.usersService.findByEmail(email);

    if (!user) {
      user = await this.usersService.create({
        username: dto.username?.trim() || this.buildUsername(email),
        email,
        password: randomToken(24),
        termsAccepted: true,
      });
    }

    try {
      account = await this.socialAccountsRepository.save(
        this.socialAccountsRepository.create({
          userId: user.id,
          provider: dto.provider,
          providerUserId: dto.providerUserId,
        }),
      );
    } catch {
      // Bisa terjadi race condition saat dua request menautkan akun yang sama.
      const existing = await this.socialAccountsRepository.findOne({
        where: { provider: dto.provider, providerUserId: dto.providerUserId },
      });
      if (!existing) {
        throw new BadRequestException('Gagal menautkan akun sosial');
      }
      account = existing;
    }

    return this.issueSession(user, userAgent);
  }

  async listSocialAccounts(userId: string): Promise<SocialAccountInfo[]> {
    const accounts = await this.socialAccountsRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });

    return accounts.map((account) => ({
      id: account.id,
      provider: account.provider,
      providerUserId: account.providerUserId,
      createdAt: account.createdAt,
    }));
  }

  async unlinkSocialAccount(userId: string, accountId: string): Promise<void> {
    const result = await this.socialAccountsRepository.delete({
      id: accountId,
      userId,
    });

    if (!result.affected) {
      throw new NotFoundException('Akun sosial tidak ditemukan');
    }
  }

  async forgotPassword(
    dto: ForgotPasswordDto,
  ): Promise<{ success: boolean; message: string; resetCode?: string }> {
    const email = dto.email.trim().toLowerCase();
    const message =
      'Jika email terdaftar, kode reset password sudah dibuat dan dikirim.';

    const user = await this.usersService.findByEmail(email);
    if (!user) {
      // Tetap balas sukses agar penyerang tidak bisa menebak email terdaftar.
      return { success: true, message };
    }

    // Kode lama yang belum terpakai dianggap hangus.
    await this.resetCodesRepository.update(
      { email, usedAt: IsNull() },
      { usedAt: new Date() },
    );

    const code = randomNumericCode(6);
    await this.resetCodesRepository.save(
      this.resetCodesRepository.create({
        email,
        codeHash: sha256(code),
        expiresAt: new Date(Date.now() + RESET_CODE_TTL_MS),
        usedAt: null,
        attempts: 0,
      }),
    );

    const response: { success: boolean; message: string; resetCode?: string } = {
      success: true,
      message,
    };

    // Hanya untuk kebutuhan development/testing. Jangan dikembalikan di production.
    if (process.env.NODE_ENV !== 'production') {
      response.resetCode = code;
    }

    return response;
  }

  async verifyResetCode(
    dto: VerifyResetCodeDto,
  ): Promise<{ valid: boolean; expiresAt: Date }> {
    const record = await this.consumeResetCode(dto.email, dto.code);
    return { valid: true, expiresAt: record.expiresAt };
  }

  async resetPassword(
    dto: ResetPasswordDto,
  ): Promise<{ success: boolean; message: string }> {
    const record = await this.consumeResetCode(dto.email, dto.code);

    record.usedAt = new Date();
    await this.resetCodesRepository.save(record);

    const user = await this.usersService.findByEmail(dto.email);
    if (!user) {
      throw new NotFoundException('User tidak ditemukan');
    }

    await this.usersService.updatePassword(dto.email, dto.newPassword);
    await this.revokeAll(user.id);

    return {
      success: true,
      message: 'Password berhasil direset. Silakan login dengan password baru.',
    };
  }

  private async issueSession(user: User, userAgent?: string): Promise<SessionResult> {
    const accessToken = this.jwtService.issue({
      sub: user.id,
      username: user.username,
      email: user.email,
    });

    const refreshToken = randomToken(48);
    await this.refreshTokensRepository.save(
      this.refreshTokensRepository.create({
        userId: user.id,
        tokenHash: sha256(refreshToken),
        expiresAt: new Date(Date.now() + REFRESH_TOKEN_TTL_MS),
        revokedAt: null,
        userAgent: userAgent ? userAgent.slice(0, 500) : null,
      }),
    );

    return {
      user: UsersService.toPublic(user),
      tokenType: 'Bearer',
      accessToken,
      refreshToken,
      expiresIn: this.jwtService.ttlSeconds,
    };
  }

  private async revokeAll(userId: string): Promise<void> {
    await this.refreshTokensRepository.update(
      { userId, revokedAt: IsNull() },
      { revokedAt: new Date() },
    );
  }

  private async consumeResetCode(
    rawEmail: string,
    code: string,
  ): Promise<PasswordResetCode> {
    const email = rawEmail.trim().toLowerCase();
    const record = await this.resetCodesRepository.findOne({
      where: { email, usedAt: IsNull() },
      order: { createdAt: 'DESC' },
    });

    if (!record) {
      throw new BadRequestException('Kode reset tidak valid atau sudah kedaluwarsa');
    }

    if (record.expiresAt.getTime() <= Date.now()) {
      record.usedAt = new Date();
      await this.resetCodesRepository.save(record);
      throw new BadRequestException('Kode reset sudah kedaluwarsa');
    }

    if (record.attempts >= RESET_CODE_MAX_ATTEMPTS) {
      record.usedAt = new Date();
      await this.resetCodesRepository.save(record);
      throw new BadRequestException(
        'Terlalu banyak percobaan. Silakan minta kode reset baru.',
      );
    }

    if (record.codeHash !== sha256(code)) {
      record.attempts += 1;
      if (record.attempts >= RESET_CODE_MAX_ATTEMPTS) {
        record.usedAt = new Date();
      }
      await this.resetCodesRepository.save(record);
      throw new BadRequestException('Kode reset tidak valid');
    }

    return record;
  }

  private buildUsername(email: string): string {
    const base =
      email
        .split('@')[0]
        .toLowerCase()
        .replace(/[^a-z0-9_]/g, '_')
        .slice(0, 35) || 'user';
    const suffix = randomToken(6).replace(/[^a-z0-9]/gi, '').slice(0, 6);

    return `${base}_${suffix || 'user'}`.slice(0, 50);
  }
}
