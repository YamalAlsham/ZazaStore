import { MulterModule } from '@nestjs/platform-express';
import { Module } from '@nestjs/common';
import { CategoryService } from './category.service';
import { CategoryController } from './category.controller';
import { Category } from './entities/category.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TextContent } from '../text-content/entities/text-content.entity';
import { Translation } from '../translation/entities/translation.entity';
import { TextContentService } from '../text-content/text-content.service';
import { TranslationService } from '../translation/translation.service';
import { LanguageService } from '../language/language.service';
import { Language } from '../language/entities/language.entity';
import { ProductService } from '../product/product.service';
import { Product } from '../product/entities/product.entity';
import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';
import { User } from '../user/entities/user.entity';
import { ProductUnit } from '../product-unit/entities/product-unit.entity';
import { Discount } from '../discount/entities/discount.entity';
import { FavoriteProduct } from '../favorite-product/entities/favorite-product.entity';
import { DiscountSpecificUser } from '../discount-specific-user/entities/discount-specific-user.entity';
import { UserResetPassword } from '../user/entities/user-reset-password.entity';
import { UploadService } from '../upload/upload.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Category,
      TextContent,
      Translation,
      Language,
      Product,
      ProductUnit,
      User,
      Discount,
      FavoriteProduct,
      DiscountSpecificUser,
      UserResetPassword,
    ]),
  ],
  controllers: [CategoryController],
  providers: [
    CategoryService,
    TextContentService,
    TranslationService,
    LanguageService,
    ProductService,
    JwtService,
    UserService,
    UploadService,
  ],
})
export class CategoryModule {}
