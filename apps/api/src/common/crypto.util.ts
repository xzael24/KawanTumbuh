import {
  createHash,
  randomBytes,
  randomInt,
  scryptSync,
  timingSafeEqual,
} from 'node:crypto';

/**
 * Hash password memakai scrypt (built-in Node, tanpa dependency tambahan).
 * Format hasil: `scrypt$<salt>$<derivedKey>`
 */
export function hashPassword(password: string): string {
  const salt = randomBytes(16).toString('hex');
  const derived = scryptSync(password, salt, 64).toString('hex');
  return `scrypt$${salt}$${derived}`;
}

/**
 * Verifikasi password terhadap hash tersimpan. Aman terhadap timing attack.
 */
export function verifyPassword(password: string, stored: string): boolean {
  const [scheme, salt, hash] = stored.split('$');
  if (scheme !== 'scrypt' || !salt || !hash) {
    return false;
  }

  const derived = scryptSync(password, salt, 64);
  const expected = Buffer.from(hash, 'hex');

  return derived.length === expected.length && timingSafeEqual(derived, expected);
}

/**
 * SHA-256 dipakai untuk menyimpan hash refresh token & kode reset password.
 */
export function sha256(value: string): string {
  return createHash('sha256').update(value).digest('hex');
}

/**
 * Token acak (base64url) untuk refresh token / password sementara.
 */
export function randomToken(bytes = 32): string {
  return randomBytes(bytes).toString('base64url');
}

/**
 * Kode angka acak, misal 6 digit untuk reset password.
 */
export function randomNumericCode(digits = 6): string {
  const min = 10 ** (digits - 1);
  const max = 10 ** digits - 1;
  return String(randomInt(min, max + 1));
}
