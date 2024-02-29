import { EmailService } from './../../email/email.service';
import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  UseGuards,
  Query,
} from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { ApiTags } from '@nestjs/swagger';
import { AccessTokenGuard } from '../auth/guards/accessToken.guard';
import { IsAdminGuard } from '../auth/guards/is-admin.guard';
import { PaginationWithSearch } from 'src/core/query/pagination-with-search.query';
import { UserNotFoundGuard } from './guards/user-not-found.guard';
import { DoesUserResetTokenExistGuard } from 'src/email/guards/does-user-reset-token-exist.guard';
import { ValidateResetTokenGuard } from 'src/email/guards/validate-reset-token.guard';
import { ResetPasswordDto } from 'src/email/dto/reset-password.dto';
import { UserResetPassword } from './entities/user-reset-password.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

@ApiTags('user')
@Controller('user')
export class UserController {
  constructor(
    private readonly userService: UserService,
    private readonly emailService: EmailService,
    @InjectRepository(UserResetPassword)
    private readonly userResetPasswordRepository: Repository<UserResetPassword>,
  ) {}

  @Post()
  create(@Body() createUserDto: CreateUserDto) {
    return this.userService.create(createUserDto);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard)
  @Get()
  findAll(@Query() query: PaginationWithSearch) {
    return this.userService.findAll(query);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard, UserNotFoundGuard)
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.userService.findOne(+id);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard, UserNotFoundGuard)
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.userService.remove(+id);
  }

  // check if user exists
  // delete user reset token if exists
  @UseGuards(DoesUserResetTokenExistGuard)
  @Post('forgot-password')
  async forgotPassword(@Body('email') email: string) {
    const token = await this.userService.generateResetToken(email);

    try {
      await this.emailService.sendResetPasswordEmail(email, token);
    } catch (err) {
      throw new Error(err);
    }
    return {
      message: 'Email reset code sent successfully',
      statusCode: 201,
    };
  }

  @UseGuards(ValidateResetTokenGuard)
  @Post('validate-token')
  validateToken() {
    return {
      message: 'token is valid',
    };
  }

  @UseGuards(ValidateResetTokenGuard)
  @Post('reset-password')
  async resetPassword(@Body() resetPasswordDto: ResetPasswordDto) {
    const user = await this.userService.findByEmail(resetPasswordDto.email);
    const newUser = await this.userService.resetPassword(
      user,
      resetPasswordDto.password,
    );

    const userResetToken = await this.userResetPasswordRepository.findOneBy({
      userId: user.id,
    });

    await this.userResetPasswordRepository.remove(userResetToken);

    return newUser;
  }
}
