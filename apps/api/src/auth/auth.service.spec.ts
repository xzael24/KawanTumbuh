import { getRepositoryToken } from '@nestjs/typeorm';
import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from '../users/users.service.js';
import { AuthService } from './auth.service.js';
import { PasswordResetCode } from './entities/password-reset-code.entity.js';
import { RefreshToken } from './entities/refresh-token.entity.js';
import { SocialAccount } from './entities/social-account.entity.js';
import { JwtService } from './jwt.service.js';

describe('AuthService', () => {
  let service: AuthService;

  beforeEach(async () => {
    const repository = {
      create: vi.fn(),
      save: vi.fn(),
      find: vi.fn(),
      findOne: vi.fn(),
      update: vi.fn(),
      delete: vi.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: UsersService, useValue: {} },
        { provide: JwtService, useValue: { issue: vi.fn(), ttlSeconds: 3600 } },
        { provide: getRepositoryToken(RefreshToken), useValue: repository },
        { provide: getRepositoryToken(SocialAccount), useValue: repository },
        { provide: getRepositoryToken(PasswordResetCode), useValue: repository },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
