import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  Patch,
  UseGuards,
} from '@nestjs/common';
import { CurrentUser } from '../auth/current-user.decorator.js';
import { JwtAuthGuard } from '../auth/jwt-auth.guard.js';
import { UpdateUserDto } from './dto/update-user.dto.js';
import { PublicUser, UsersService } from './users.service.js';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  /**
   * TODO: batasi ke role admin ketika sistem role sudah ada.
   */
  @Get()
  findAll(): Promise<PublicUser[]> {
    return this.usersService.findAll();
  }

  @Get('me')
  async findMe(@CurrentUser('sub') userId: string): Promise<PublicUser> {
    const user = await this.usersService.findById(userId);
    return UsersService.toPublic(user);
  }

  @Patch('me')
  updateMe(
    @CurrentUser('sub') userId: string,
    @Body() dto: UpdateUserDto,
  ): Promise<PublicUser> {
    return this.usersService.update(userId, dto);
  }

  @Delete('me')
  @HttpCode(204)
  async removeMe(@CurrentUser('sub') userId: string): Promise<void> {
    await this.usersService.remove(userId);
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<PublicUser> {
    const user = await this.usersService.findById(id);
    return UsersService.toPublic(user);
  }
}
