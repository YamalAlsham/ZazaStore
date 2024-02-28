import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { JwtService } from '@nestjs/jwt';
import { UserResetPassword } from './entities/user-reset-password.entity';
import { EmailService } from 'src/email/email.service';

@Module({
  imports: [TypeOrmModule.forFeature([User, UserResetPassword])],
  controllers: [UserController],
  providers: [UserService, JwtService, EmailService],
  exports: [UserService],
})
export class UserModule {}
