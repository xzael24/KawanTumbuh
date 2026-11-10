import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { QueryFailedError, Repository } from 'typeorm';
import { hashPassword } from '../common/crypto.util.js';
import { CreateUserDto } from './dto/create-user.dto.js';
import { UpdateUserDto } from './dto/update-user.dto.js';
import { User } from './entities/user.entity.js';

export interface PublicUser {
  id: string;
  username: string;
  email: string;
  termsAcceptedAt: Date;
  createdAt: Date;
  updatedAt: Date;
}

const UNIQUE_VIOLATION = '23505';

function isUniqueViolation(error: unknown): boolean {
  if (!(error instanceof QueryFailedError)) {
    return false;
  }

  const driverError = error.driverError as { code?: string } | undefined;
  return (driverError?.code ?? (error as unknown as { code?: string }).code) === UNIQUE_VIOLATION;
}

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
  ) {}

  static toPublic(user: User): PublicUser {
    return {
      id: user.id,
      username: user.username,
      email: user.email,
      termsAcceptedAt: user.terms_accepted_at,
      createdAt: user.created_at,
      updatedAt: user.updated_at,
    };
  }

  async create(dto: CreateUserDto): Promise<User> {
    const email = dto.email.trim().toLowerCase();

    if (await this.existsByEmail(email)) {
      throw new ConflictException('Email sudah terdaftar');
    }

    if (await this.existsByUsername(dto.username)) {
      throw new ConflictException('Username sudah digunakan');
    }

    const user = this.usersRepository.create({
      username: dto.username.trim(),
      email,
      password: hashPassword(dto.password),
      terms_accepted_at: new Date(),
    });

    try {
      return await this.usersRepository.save(user);
    } catch (error) {
      if (isUniqueViolation(error)) {
        throw new ConflictException('Email atau username sudah digunakan');
      }
      throw error;
    }
  }

  async findAll(): Promise<PublicUser[]> {
    const users = await this.usersRepository.find({
      order: { created_at: 'DESC' },
    });

    return users.map((user) => UsersService.toPublic(user));
  }

  async findById(id: string): Promise<User> {
    const user = await this.usersRepository.findOne({ where: { id } });

    if (!user) {
      throw new NotFoundException('User tidak ditemukan');
    }

    return user;
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { email: email.trim().toLowerCase() },
    });
  }

  async findByUsername(username: string): Promise<User | null> {
    return this.usersRepository.findOne({
      where: { username: username.trim() },
    });
  }

  async existsByEmail(email: string): Promise<boolean> {
    return this.usersRepository.exists({
      where: { email: email.trim().toLowerCase() },
    });
  }

  async existsByUsername(username: string): Promise<boolean> {
    return this.usersRepository.exists({
      where: { username: username.trim() },
    });
  }

  async update(id: string, dto: UpdateUserDto): Promise<PublicUser> {
    const user = await this.findById(id);

    if (dto.username && dto.username.trim() !== user.username) {
      if (await this.existsByUsername(dto.username)) {
        throw new ConflictException('Username sudah digunakan');
      }
      user.username = dto.username.trim();
    }

    if (dto.email && dto.email.trim().toLowerCase() !== user.email) {
      const email = dto.email.trim().toLowerCase();
      if (await this.existsByEmail(email)) {
        throw new ConflictException('Email sudah terdaftar');
      }
      user.email = email;
    }

    if (dto.password) {
      user.password = hashPassword(dto.password);
    }

    if (dto.termsAccepted) {
      user.terms_accepted_at = new Date();
    }

    try {
      const saved = await this.usersRepository.save(user);
      return UsersService.toPublic(saved);
    } catch (error) {
      if (isUniqueViolation(error)) {
        throw new ConflictException('Email atau username sudah digunakan');
      }
      throw error;
    }
  }

  async updatePassword(email: string, plainPassword: string): Promise<void> {
    const user = await this.findByEmail(email);
    if (!user) {
      throw new NotFoundException('User tidak ditemukan');
    }

    user.password = hashPassword(plainPassword);
    await this.usersRepository.save(user);
  }

  async remove(id: string): Promise<void> {
    const result = await this.usersRepository.delete({ id });
    if (!result.affected) {
      throw new NotFoundException('User tidak ditemukan');
    }
  }
}
