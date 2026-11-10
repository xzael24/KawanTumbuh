import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { CurrentUser } from '../auth/current-user.decorator.js';
import { JwtAuthGuard } from '../auth/jwt-auth.guard.js';
import { ChildrenService } from './children.service.js';
import { CreateChildDto } from './dto/create-child.dto.js';
import { UpdateChildDto } from './dto/update-child.dto.js';
import { Child } from './entities/child.entity.js';

@Controller('children')
@UseGuards(JwtAuthGuard)
export class ChildrenController {
  constructor(private readonly childrenService: ChildrenService) {}

  @Post()
  create(@CurrentUser('sub') userId: string, @Body() dto: CreateChildDto): Promise<Child> {
    return this.childrenService.create(userId, dto);
  }

  @Get()
  findAll(@CurrentUser('sub') userId: string): Promise<Child[]> {
    return this.childrenService.findAllByUser(userId);
  }

  @Get(':id')
  findOne(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ): Promise<Child> {
    return this.childrenService.findOne(userId, id);
  }

  @Patch(':id')
  update(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
    @Body() dto: UpdateChildDto,
  ): Promise<Child> {
    return this.childrenService.update(userId, id, dto);
  }

  @Delete(':id')
  @HttpCode(204)
  async remove(
    @CurrentUser('sub') userId: string,
    @Param('id') id: string,
  ): Promise<void> {
    await this.childrenService.remove(userId, id);
  }
}
