import { ExecutionContext, createParamDecorator } from '@nestjs/common';
import type { AuthenticatedRequest } from './jwt-auth.guard.js';
import { JwtPayload } from './jwt.service.js';

/**
 * Cara pakai:
 *   @CurrentUser() user: JwtPayload
 *   @CurrentUser('sub') userId: string
 */
export const CurrentUser = createParamDecorator(
  (data: keyof JwtPayload | undefined, context: ExecutionContext) => {
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const user = request.user;

    return data ? user?.[data] : user;
  },
);
