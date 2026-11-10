import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateChildDto } from './dto/create-child.dto.js';
import { UpdateChildDto } from './dto/update-child.dto.js';
import { Child } from './entities/child.entity.js';

@Injectable()
export class ChildrenService {
  constructor(
    @InjectRepository(Child)
    private readonly childrenRepository: Repository<Child>,
  ) {}

  create(userId: string, dto: CreateChildDto): Promise<Child> {
    const child = this.childrenRepository.create({
      userId,
      name: dto.name.trim(),
      gender: dto.gender,
      dateOfBirth: dto.dateOfBirth,
      photo: dto.photo ?? null,
    });

    return this.childrenRepository.save(child);
  }

  findAllByUser(userId: string): Promise<Child[]> {
    return this.childrenRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(userId: string, id: string): Promise<Child> {
    const child = await this.childrenRepository.findOne({
      where: { id, userId },
    });

    if (!child) {
      throw new NotFoundException('Profil anak tidak ditemukan');
    }

    return child;
  }

  async update(userId: string, id: string, dto: UpdateChildDto): Promise<Child> {
    const child = await this.findOne(userId, id);

    if (dto.name !== undefined) {
      child.name = dto.name.trim();
    }
    if (dto.gender !== undefined) {
      child.gender = dto.gender;
    }
    if (dto.dateOfBirth !== undefined) {
      child.dateOfBirth = dto.dateOfBirth;
    }
    if (dto.photo !== undefined) {
      child.photo = dto.photo;
    }

    return this.childrenRepository.save(child);
  }

  async remove(userId: string, id: string): Promise<void> {
    const result = await this.childrenRepository.delete({ id, userId });
    if (!result.affected) {
      throw new NotFoundException('Profil anak tidak ditemukan');
    }
  }
}
