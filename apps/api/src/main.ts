import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module.js';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // CORS_ORIGINS: daftar origin dipisah koma, atau "*" untuk development.
  const corsOrigins = process.env.CORS_ORIGINS?.trim();
  app.enableCors({
    origin:
      corsOrigins && corsOrigins !== '*'
        ? corsOrigins.split(',').map((origin) => origin.trim())
        : true,
    credentials: true,
  });

  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

  // Semua route bisnis di bawah /api/v1 (sesuai kontrak & konfigurasi NGINX).
  // /health sengaja dikecualikan agar healthcheck Docker/monitoring tetap simpel.
  app.setGlobalPrefix('api/v1', { exclude: ['health'] });

  const port = process.env.PORT ?? 3000;
  await app.listen(port);
  console.log(`[KAWANTUMBUH API] Running on http://localhost:${port}/api/v1`);
}
await bootstrap();
