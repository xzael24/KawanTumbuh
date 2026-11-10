import {
  IsDateString,
  IsEnum,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
} from 'class-validator';
import { Gender } from '../entities/child.entity.js';

export class CreateChildDto {
  /**
   * Opsional dan akan diabaikan jika request memakai JWT.
   * Pemilik data selalu diambil dari token (`sub`).
   */
  @IsOptional()
  @IsUUID()
  userId?: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  name: string;

  @IsEnum(Gender, { message: 'gender harus "male" atau "female"' })
  gender: Gender;

  @IsDateString({}, { message: 'dateOfBirth harus format tanggal ISO, misal 2018-05-14' })
  dateOfBirth: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  photo?: string;
}
