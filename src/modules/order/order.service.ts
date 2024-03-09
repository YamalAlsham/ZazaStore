import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Order } from './entities/order.entity';
import { Repository } from 'typeorm';
import { Pagination } from 'src/core/query/pagination.query';
import { getOrderByCondition } from 'src/core/helpers/sort.helper';
import { LanguageQuery } from 'src/core/query/language.query';
import { LanguageCodeEnum } from '../language/helper/language-enum';
import { UpdateStatusDto } from './dto/update-status.dto';
import { StatusEnum } from './helpers/status-enum';

@Injectable()
export class OrderService {
  constructor(
    @InjectRepository(Order)
    private readonly orderRepository: Repository<Order>,
  ) {}

  create(userId: number) {
    const order = this.orderRepository.create({
      userId,
    });
    return this.orderRepository.save(order);
  }

  async findMyOrders(userId: number, query: Pagination, status: string) {
    let whereClause = { userId };
    if (status !== StatusEnum.ALL) {
      whereClause['status'] = status;
    }

    const [orders, count] = await this.orderRepository.findAndCount({
      where: whereClause,
      take: query.limit,
      skip: (query.page - 1) * query.limit,
      order: getOrderByCondition(query.sort),
    });

    return {
      count,
      orders,
    };
  }

  async findAll(query: Pagination, status: string) {
    let whereClause = {};
    if (status !== StatusEnum.ALL) {
      whereClause = { status };
    }

    const [orders, count] = await this.orderRepository.findAndCount({
      where: whereClause,
      take: query.limit,
      skip: (query.page - 1) * query.limit,
      relations: {
        user: true,
      },
      order: getOrderByCondition(query.sort),
    });

    return {
      count,
      orders,
    };
  }

  async findAllByUserId(userId: number, query: Pagination, status: string) {
    let whereClause = { userId };
    if (status !== StatusEnum.ALL) {
      whereClause['status'] = status;
    }

    const [orders, count] = await this.orderRepository.findAndCount({
      where: whereClause,
      take: query.limit,
      skip: (query.page - 1) * query.limit,
      relations: {
        user: true,
      },
      order: getOrderByCondition(query.sort),
    });

    return {
      count,
      orders,
    };
  }

  async findOne(id: number, language: LanguageQuery) {
    const code = language.language;
    const qb = this.createQueryBuilderForFindOne(id, code);
    const result = await qb.getOne();

    return this.formatResponse(result, code);
  }

  private createQueryBuilderForFindOne(id: number, code: string) {
    let qb = this.orderRepository
      .createQueryBuilder('order')
      .where('order.id = :id', { id })
      .leftJoin('order.productOrders', 'productOrders')
      .leftJoin('productOrders.productUnit', 'productUnit')
      .leftJoin('productUnit.product', 'product')
      .leftJoin('product.tax', 'tax')
      .leftJoin('productUnit.unit', 'unit')
      .select([
        'order',
        'productOrders.id',
        'productOrders.amount',
        'productOrders.totalPrice',
        'productOrders.totalPriceAfterTax',
        'productUnit.id',
        'product.id',
        'product.image',
        'product.barCode',
        'unit.id',
        'tax.percent',
      ]);

    if (code == LanguageCodeEnum.DE) {
      qb = this.addGermanTextContent(qb, code);
    } else {
      qb = this.addOtherTextContent(qb, code);
    }

    return qb;
  }

  private addGermanTextContent(qb: any, code: LanguageCodeEnum) {
    return qb
      .leftJoinAndSelect(
        'productUnit.textContent',
        'productUnitTextContent',
        'productUnitTextContent.code = :code',
        { code },
      )
      .leftJoinAndSelect(
        'product.textContent',
        'productTextContent',
        'productTextContent.code = :code',
        { code },
      )
      .leftJoinAndSelect(
        'unit.textContent',
        'unitTextContent',
        'unitTextContent.code = :code',
        { code },
      );
  }

  private addOtherTextContent(qb: any, code: string) {
    return qb
      .leftJoinAndSelect('productUnit.textContent', 'productUnitTextContent')
      .leftJoinAndSelect(
        'productUnitTextContent.translations',
        'productUnitTranslation',
        'productUnitTranslation.code = :code',
        { code },
      )
      .leftJoinAndSelect('product.textContent', 'productTextContent')
      .leftJoinAndSelect(
        'productTextContent.translations',
        'productTranslation',
        'productTranslation.code = :code',
        { code },
      )
      .leftJoinAndSelect('unit.textContent', 'unitTextContent')
      .leftJoinAndSelect(
        'unitTextContent.translations',
        'unitTranslation',
        'unitTranslation.code = :code',
        { code },
      );
  }

  private formatResponse(result: any, code: string) {
    // Group product orders by product
    const groupedProductOrders = result.productOrders.reduce(
      (groups, productOrder) => {
        const key = productOrder.productUnit.product.id;
        if (!groups[key]) {
          groups[key] = {
            product: {
              id: productOrder.productUnit.product.id,
              image: productOrder.productUnit.product.image
                ? process.env.IMAGES_PREFIX_URL +
                  productOrder.productUnit.product.image
                : null,
              barCode: productOrder.productUnit.product.barCode,
              tax: productOrder.productUnit.product.tax.percent,
              translatedProduct:
                code == LanguageCodeEnum.DE
                  ? productOrder.productUnit.product.textContent.originalText
                  : productOrder.productUnit.product.textContent
                      ?.translations[0]?.translation ||
                    productOrder.productUnit.product.textContent.originalText,
              productUnit: [],
            },
          };
        }
        const productUnitOriginalText =
          productOrder.productUnit.textContent.originalText;
        const productUnitTranslation =
          code != LanguageCodeEnum.DE
            ? productOrder.productUnit.textContent?.translations[0]?.translation
            : null;
        const unitOriginalText =
          productOrder.productUnit.unit.textContent.originalText;
        const unitTranslation =
          code != LanguageCodeEnum.DE
            ? productOrder.productUnit.unit.textContent?.translations[0]
                ?.translation
            : null;
        groups[key].product.productUnit.push({
          id: productOrder.productUnit.id,
          translatedProductUnit:
            code == LanguageCodeEnum.DE
              ? productUnitOriginalText
              : productUnitTranslation || productUnitOriginalText,
          unit: {
            id: productOrder.productUnit.unit.id,
            translatedUnit:
              code == LanguageCodeEnum.DE
                ? unitOriginalText
                : unitTranslation || unitOriginalText,
          },
          productOrders: {
            id: productOrder.id,
            amount: productOrder.amount,
            totalPrice: productOrder.totalPrice,
            totalPriceAfterTax: productOrder.totalPriceAfterTax,
          },
        });
        return groups;
      },
      {},
    );

    // Map each group to the desired structure
    const products = Object.values(groupedProductOrders).map(
      (group: any) => group.product,
    );

    return {
      id: result.id,
      userId: result.userId,
      createdAt: result.createdAt,
      status: result.status,
      totalPrice: result.totalPrice,
      totalPriceAfterTax: result.totalPriceAfterTax,
      products,
    };
  }

  async updateStatus(id: number, updateStatusDto: UpdateStatusDto) {
    const order = await this.orderRepository.findOneBy({
      id,
    });

    return this.orderRepository.save({
      ...order,
      status: updateStatusDto.status,
    });
  }
}
