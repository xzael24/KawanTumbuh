import { getRepositoryToken } from '@nestjs/typeorm';
import { Test, TestingModule } from '@nestjs/testing';
import { ChildrenService } from './children.service.js';
import { Child } from './entities/child.entity.js';

describe('ChildrenService', () => {
  let service: ChildrenService;

  beforeEach(async () => {
    const repository = {
      create: vi.fn(),
      save: vi.fn(),
      find: vi.fn(),
      findOne: vi.fn(),
      delete: vi.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ChildrenService,
        { provide: getRepositoryToken(Child), useValue: repository },
      ],
    }).compile();

    service = module.get<ChildrenService>(ChildrenService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
