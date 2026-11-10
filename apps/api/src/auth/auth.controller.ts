import {
  Body,
  Controller,
  Delete,
  Get,
  Headers,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from './auth.service.js';
import { CurrentUser } from './current-user.decorator.js';
import { ForgotPasswordDto } from './dto/forgot-password.dto.js';
import { LoginDto } from './dto/login.dto.js';
import { LogoutDto } from './dto/logout.dto.js';
import { RefreshTokenDto } from './dto/refresh-token.dto.js';
import { ResetPasswordDto } from './dto/reset-password.dto.js';
import { SocialLoginDto } from './dto/social-login.dto.js';
import { VerifyResetCodeDto } from './dto/verify-reset-code.dto.js';
import { JwtAuthGuard } from './jwt-auth.guard.js';
import { CreateUserDto } from '../users/dto/create-user.dto.js';
import { PublicUser, UsersService } from '../users/users.service.js';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
  ) {}

  @Post('register')
  register(@Body() dto: CreateUserDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  login(@Body() dto: LoginDto, @Headers('user-agent') userAgent?: string) {
    return this.authService.login(dto, userAgent);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  refresh(@Body() dto: RefreshTokenDto, @Headers('user-agent') userAgent?: string) {
    return this.authService.refresh(dto, userAgent);
  }

  @Post('logout')
  @HttpCode(HttpStatus.OK)
  logout(@Body() dto: LogoutDto) {
    return this.authService.logout(dto);
  }

  @Post('logout-all')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  logoutAll(@CurrentUser('sub') userId: string) {
    return this.authService.logoutAll(userId);
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  async me(@CurrentUser('sub') userId: string): Promise<PublicUser> {
    const user = await this.usersService.findById(userId);
    return UsersService.toPublic(user);
  }

  @Get('sessions')
  @UseGuards(JwtAuthGuard)
  listSessions(@CurrentUser('sub') userId: string) {
    return this.authService.listSessions(userId);
  }

  @Delete('sessions/:id')
  @UseGuards(JwtAuthGuard)
  revokeSession(
    @CurrentUser('sub') userId: string,
    @Param('id') sessionId: string,
  ) {
    return this.authService.revokeSession(userId, sessionId);
  }

  @Post('social')
  @HttpCode(HttpStatus.OK)
  socialLogin(
    @Body() dto: SocialLoginDto,
    @Headers('user-agent') userAgent?: string,
  ) {
    return this.authService.socialLogin(dto, userAgent);
  }

  @Get('social')
  @UseGuards(JwtAuthGuard)
  listSocialAccounts(@CurrentUser('sub') userId: string) {
    return this.authService.listSocialAccounts(userId);
  }

  @Delete('social/:id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @UseGuards(JwtAuthGuard)
  async unlinkSocialAccount(
    @CurrentUser('sub') userId: string,
    @Param('id') accountId: string,
  ): Promise<void> {
    await this.authService.unlinkSocialAccount(userId, accountId);
  }

  @Post('forgot-password')
  @HttpCode(HttpStatus.OK)
  forgotPassword(@Body() dto: ForgotPasswordDto) {
    return this.authService.forgotPassword(dto);
  }

  @Post('verify-reset-code')
  @HttpCode(HttpStatus.OK)
  verifyResetCode(@Body() dto: VerifyResetCodeDto) {
    return this.authService.verifyResetCode(dto);
  }

  @Post('reset-password')
  @HttpCode(HttpStatus.OK)
  resetPassword(@Body() dto: ResetPasswordDto) {
    return this.authService.resetPassword(dto);
  }
}
