import { Module } from '@nestjs/common';
import { ProductService } from './product.service';
import { ProductController } from './product.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Product } from './entities/product.entity';
import { TextContent } from '../text-content/entities/text-content.entity';
import { Tax } from '../tax/entities/tax.entity';
import { Category } from '../category/entities/category.entity';
import { Language } from '../language/entities/language.entity';
import { LanguageService } from '../language/language.service';
import { TextContentService } from '../text-content/text-content.service';
import { TranslationService } from '../translation/translation.service';
import { Translation } from '../translation/entities/translation.entity';
import { TaxService } from '../tax/tax.service';
import { CategoryService } from '../category/category.service';
import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';
import { User } from '../user/entities/user.entity';
import { ProductUnitService } from '../product-unit/product-unit.service';
import { ProductUnit } from '../product-unit/entities/product-unit.entity';
import { Unit } from '../unit/entities/unit.entity';
import { Discount } from '../discount/entities/discount.entity';
import { FavoriteProductService } from '../favorite-product/favorite-product.service';
import { FavoriteProduct } from '../favorite-product/entities/favorite-product.entity';
import { DiscountSpecificUser } from '../discount-specific-user/entities/discount-specific-user.entity';
import { UserResetPassword } from '../user/entities/user-reset-password.entity';
import { UploadService } from '../upload/upload.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      TextContent,
      Tax,
      Category,
      Language,
      Translation,
      User,
      ProductUnit,
      Unit,
      Discount,
      FavoriteProduct,
      DiscountSpecificUser,
      UserResetPassword,
    ]),
  ],
  controllers: [ProductController],
  providers: [
    ProductService,
    LanguageService,
    TextContentService,
    TranslationService,
    TaxService,
    CategoryService,
    JwtService,
    UserService,
    ProductUnitService,
    FavoriteProductService,
    UploadService,
  ],
})
export class ProductModule {}
