import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TokenModule } from '../auth/token.module.js';
import { ChildrenController } from './children.controller.js';
import { ChildrenService } from './children.service.js';
import { Child } from './entities/child.entity.js';

@Module({
  imports: [TypeOrmModule.forFeature([Child]), TokenModule],
  controllers: [ChildrenController],
  providers: [ChildrenService],
  exports: [ChildrenService],
})
export class ChildrenModule {}
