import {
  IsEmail,
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';
import { SocialProvider } from '../entities/social-account.entity.js';

export class SocialLoginDto {
  @IsEnum(SocialProvider)
  provider: SocialProvider;

  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  providerUserId: string;

  /**
   * Wajib dikirim jika akun sosial belum pernah ditautkan, supaya server
   * bisa mencocokkan/membuat user berdasarkan email.
   */
  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  username?: string;

  /**
   * Token dari provider. Disimpan untuk hook verifikasi lanjutan.
   * TODO: verifikasi signature idToken ke Google/Facebook sebelum produksi.
   */
  @IsOptional()
  @IsString()
  idToken?: string;
}
