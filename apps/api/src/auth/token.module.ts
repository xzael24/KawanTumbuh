import { Module } from '@nestjs/common';
import { JwtAuthGuard } from './jwt-auth.guard.js';
import { JwtService } from './jwt.service.js';

/**
 * Modul kecil berisi JWT service + guard, dipakai bersama oleh
 * AuthModule, UsersModule, dan ChildrenModule tanpa circular dependency.
 */
@Module({
  providers: [JwtService, JwtAuthGuard],
  exports: [JwtService, JwtAuthGuard],
})
export class TokenModule {}
