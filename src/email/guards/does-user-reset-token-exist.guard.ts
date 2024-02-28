import {
  Injectable,
  CanActivate,
  ExecutionContext,
  Inject,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { REQUEST } from '@nestjs/core';
import { Request } from 'express';
import { UserService } from '../../modules/user/user.service';
import { USER_NOT_FOUND } from 'src/core/error/messages/user-not-found.message';
import { getLanguageFromRequest } from 'src/modules/language/helper/get-language-code.helper';
import { UserResetPassword } from 'src/modules/user/entities/user-reset-password.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';

@Injectable()
export class DoesUserResetTokenExistGuard implements CanActivate {
  constructor(
    private readonly userService: UserService,
    @InjectRepository(UserResetPassword)
    private readonly userResetPasswordRepository: Repository<UserResetPassword>,
    @Inject(REQUEST) private request: Request,
  ) {}

  async canActivate(context: ExecutionContext) {
    const request = context.switchToHttp().getRequest();
    const email: string = request.body.email;
    const language = getLanguageFromRequest(this.request);
    const user = await this.userService.findByEmail(email);
    if (!user) throw new NotFoundException(USER_NOT_FOUND.getMessage(language));

    const userResetToken = await this.userResetPasswordRepository.findOneBy({
      userId: user.id,
    });

    if (userResetToken)
      await this.userResetPasswordRepository.remove(userResetToken);
    return true;
  }
}
