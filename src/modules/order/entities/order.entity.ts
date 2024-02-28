import { ProductOrder } from 'src/modules/product-order/entities/product-order.entity';
import { User } from 'src/modules/user/entities/user.entity';
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { StatusEnum } from '../helpers/status-enum';

@Entity()
export class Order {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  userId: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @Column({ type: 'enum', enum: StatusEnum, default: StatusEnum.PENDING })
  status: string;

  @Column()
  totalPrice: number;

  @ManyToOne(() => User, (user) => user.orders, {
    onDelete: 'CASCADE',
  })
  user: User;

  @OneToMany(() => ProductOrder, (productOrder) => productOrder.order)
  productOrders: ProductOrder[];
}
