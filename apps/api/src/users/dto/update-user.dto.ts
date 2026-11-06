import {
  IsOptional,
  IsString,
  IsNotEmpty,
  MaxLength,
  IsEmail,
  MinLength,
  IsBoolean,
  Equals,
} from 'class-validator';

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  username?: string;

  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  @IsString()
  @MinLength(8)
  password?: string;

  @IsOptional()
  @IsBoolean()
  @Equals(true)
  termsAccepted?: boolean;
}
