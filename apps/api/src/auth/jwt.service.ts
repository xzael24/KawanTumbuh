import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createHmac, timingSafeEqual } from 'node:crypto';

export interface JwtPayload {
  sub: string;
  username: string;
  email: string;
  iat: number;
  exp: number;
}

interface SignPayload {
  sub: string;
  username: string;
  email: string;
}

function toBase64Url(value: string | Buffer): string {
  return Buffer.from(value).toString('base64url');
}

function parseTtlSeconds(value: string | undefined): number {
  const fallback = 7 * 24 * 60 * 60;
  if (!value) {
    return fallback;
  }

  const match = /^(\d+)\s*([smhd])?$/i.exec(value.trim());
  if (!match) {
    return fallback;
  }

  const amount = Number(match[1]);
  const unit = (match[2] ?? 's').toLowerCase() as 's' | 'm' | 'h' | 'd';
  const multiplier: Record<'s' | 'm' | 'h' | 'd', number> = {
    s: 1,
    m: 60,
    h: 60 * 60,
    d: 24 * 60 * 60,
  };

  return amount * multiplier[unit];
}

/**
 * Implementasi JWT HS256 minimal memakai node:crypto.
 * Tidak memakai @nestjs/jwt agar tidak menambah dependency baru.
 */
@Injectable()
export class JwtService {
  constructor(private readonly config: ConfigService) {}

  private get secret(): string {
    return this.config.get<string>('JWT_SECRET') ?? 'kawantumbuh-dev-secret-change-me';
  }

  get ttlSeconds(): number {
    return parseTtlSeconds(this.config.get<string>('JWT_EXPIRES_IN'));
  }

  private sign(encodedHeader: string, encodedPayload: string): string {
    return createHmac('sha256', this.secret)
      .update(`${encodedHeader}.${encodedPayload}`)
      .digest('base64url');
  }

  issue(payload: SignPayload): string {
    const now = Math.floor(Date.now() / 1000);
    const body: JwtPayload = {
      ...payload,
      iat: now,
      exp: now + this.ttlSeconds,
    };

    const encodedHeader = toBase64Url(JSON.stringify({ alg: 'HS256', typ: 'JWT' }));
    const encodedPayload = toBase64Url(JSON.stringify(body));
    const signature = this.sign(encodedHeader, encodedPayload);

    return `${encodedHeader}.${encodedPayload}.${signature}`;
  }

  verify(token: string): JwtPayload {
    const parts = token.split('.');
    if (parts.length !== 3) {
      throw new UnauthorizedException('Token tidak valid');
    }

    const [encodedHeader, encodedPayload, signature] = parts;
    const expected = this.sign(encodedHeader, encodedPayload);
    const receivedBuffer = Buffer.from(signature);
    const expectedBuffer = Buffer.from(expected);

    const signatureValid =
      receivedBuffer.length === expectedBuffer.length &&
      timingSafeEqual(receivedBuffer, expectedBuffer);

    if (!signatureValid) {
      throw new UnauthorizedException('Token tidak valid');
    }

    let payload: JwtPayload;
    try {
      payload = JSON.parse(Buffer.from(encodedPayload, 'base64url').toString('utf8')) as JwtPayload;
    } catch {
      throw new UnauthorizedException('Token tidak valid');
    }

    if (!payload.sub || typeof payload.exp !== 'number' || payload.exp * 1000 <= Date.now()) {
      throw new UnauthorizedException('Token sudah kedaluwarsa');
    }

    return payload;
  }
}
