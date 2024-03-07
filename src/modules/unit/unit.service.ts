import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Unit } from './entities/unit.entity';
import { In, Repository } from 'typeorm';
import { TextContent } from '../text-content/entities/text-content.entity';
import { ProductUnitService } from '../product-unit/product-unit.service';
import { ProductUnit } from '../product-unit/entities/product-unit.entity';
import { Product } from '../product/entities/product.entity';

@Injectable()
export class UnitService {
  constructor(
    @InjectRepository(Unit) private readonly unitRepository: Repository<Unit>,
    private readonly productUnitService: ProductUnitService,
    @InjectRepository(ProductUnit)
    private readonly productUnitRepository: Repository<ProductUnit>,
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}
  async create(textContent: TextContent) {
    const unit = this.unitRepository.create({
      textContent,
    });

    const savedUnit = await this.unitRepository.save(unit);

    return this.unitRepository.findOne({
      where: { id: savedUnit.id },
      relations: ['textContent', 'textContent.translations'],
    });
  }

  async findAll(code: string) {
    const units = await this.unitRepository.find({
      where: { isDeleted: false },
      relations: ['textContent', 'textContent.translations'],
    });
    const translatedUnits = units.map((unit) => {
      const translation = unit.textContent.translations.find(
        (translation) => translation.code === code,
      );

      const translatedText = translation
        ? translation.translation
        : unit.textContent.originalText;

      return {
        id: unit.id,
        textContentId: unit.textContentId,
        translatedText: translatedText || unit.textContent.originalText, // Use originalText if translatedText is empty
      };
    });

    return {
      units: translatedUnits,
    };
  }

  findOne(id: number) {
    if (id)
      return this.unitRepository.findOne({
        where: { id, isDeleted: false },
        relations: ['textContent', 'textContent.translations'],
      });
    return null;
  }

  async findByCode(id: number, code: string) {
    const unit = await this.findOne(id);

    const translation = unit.textContent.translations.find(
      (translation) => translation.code === code,
    );

    const translatedText = translation
      ? translation.translation
      : unit.textContent.originalText;

    return {
      id: unit.id,
      textContentId: unit.textContentId,
      translatedText: translatedText || unit.textContent.originalText,
    };
  }

  async remove(id: number) {
    const unit = await this.findOne(id);
    unit.isDeleted = true;

    const productUnitsWithProductIds =
      await this.productUnitService.findByUnitId(id);

    productUnitsWithProductIds.forEach((productUnit) => {
      productUnit.isDeleted = 1;
    });

    await this.productUnitRepository.save(productUnitsWithProductIds);

    const productIds = productUnitsWithProductIds.map(
      (productUnit) => productUnit.productId,
    );

    const othersProductUnits = await this.productUnitService.findByProductIds(
      productIds,
    );

    const productIdsShouldBeDeleted = productIds.filter(
      (id) => !othersProductUnits.includes(id),
    );

    const ProductsShouldBeDeleted = await this.productRepository.find({
      where: { id: In(productIdsShouldBeDeleted) },
    });

    ProductsShouldBeDeleted.map((product) => (product.isDeleted = 1));

    await this.productRepository.save(ProductsShouldBeDeleted);

    return this.unitRepository.save(unit);
  }
}
