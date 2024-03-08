import { Injectable } from '@nestjs/common';
import { CreateProductOrderDto } from './dto/create-product-order.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { ProductOrder } from './entities/product-order.entity';
import { Repository } from 'typeorm';

@Injectable()
export class ProductOrderService {
  constructor(
    @InjectRepository(ProductOrder)
    private readonly productOrderRepository: Repository<ProductOrder>,
  ) {}
  create(createProductOrderDtoList: CreateProductOrderDto[], orderId: number) {
    const productOrderList = [];
    for (const productOrderDto of createProductOrderDtoList) {
      const createdProductOrder = this.productOrderRepository.create({
        ...productOrderDto,
        orderId,
      });
      productOrderList.push(createdProductOrder);
    }

    return this.productOrderRepository.save(productOrderList);
  }
}
