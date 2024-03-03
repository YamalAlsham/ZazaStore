import { ProductOrder } from 'src/modules/product-order/entities/product-order.entity';
import { Module } from '@nestjs/common';
import { ProductOrderService } from './product-order.service';
import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../user/entities/user.entity';
import { UserResetPassword } from '../user/entities/user-reset-password.entity';

@Module({
  imports: [TypeOrmModule.forFeature([ProductOrder, User, UserResetPassword])],
  providers: [ProductOrderService, JwtService, UserService],
})
export class ProductOrderModule {}
