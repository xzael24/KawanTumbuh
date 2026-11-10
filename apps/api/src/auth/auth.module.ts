import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from '../users/users.module.js';
import { AuthController } from './auth.controller.js';
import { AuthService } from './auth.service.js';
import { PasswordResetCode } from './entities/password-reset-code.entity.js';
import { RefreshToken } from './entities/refresh-token.entity.js';
import { SocialAccount } from './entities/social-account.entity.js';
import { TokenModule } from './token.module.js';

@Module({
  imports: [
    TypeOrmModule.forFeature([RefreshToken, SocialAccount, PasswordResetCode]),
    UsersModule,
    TokenModule,
  ],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
