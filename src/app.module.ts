import { TypeOrmModule } from '@nestjs/typeorm';
import { Module } from '@nestjs/common';
import { UserModule } from './modules/user/user.module';
import { LanguageModule } from './modules/language/language.module';
import { TextContentModule } from './modules/text-content/text-content.module';
import { CategoryModule } from './modules/category/category.module';
import { ProductModule } from './modules/product/product.module';
import { OrderModule } from './modules/order/order.module';
import { PhoneModule } from './modules/phone/phone.module';
import { FavoriteProductModule } from './modules/favorite-product/favorite-product.module';
import { ProductOrderModule } from './modules/product-order/product-order.module';
import { DiscountModule } from './modules/discount/discount.module';
import { TranslationModule } from './modules/translation/translation.module';
import { DiscountSpecificUserModule } from './modules/discount-specific-user/discount-specific-user.module';
import { dataSourceOptions } from 'db/data-source';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './modules/auth/auth.module';
import { TaxModule } from './modules/tax/tax.module';
import { UnitModule } from './modules/unit/unit.module';
import { User } from './modules/user/entities/user.entity';
import { AuthService } from './modules/auth/auth.service';
import { JwtService } from '@nestjs/jwt';
import { LanguageService } from './modules/language/language.service';
import { Language } from './modules/language/entities/language.entity';
import { AppService } from './app.service';
import { ProductUnitModule } from './modules/product-unit/product-unit.module';
import { CategoryType } from './modules/category/entities/category-type.entity';
import { MailerModule } from '@nestjs-modules/mailer';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';

@Module({
  imports: [
    TypeOrmModule.forRoot(dataSourceOptions),
    TypeOrmModule.forFeature([User, Language, CategoryType]),
    ConfigModule.forRoot({ isGlobal: true }),
    MailerModule.forRoot({
      transport: {
        host: process.env.SENDGRID_API_HOST,
        auth: {
          user: process.env.SENDGRID_API_USER_NAME,
          pass: process.env.SENDGRID_API_KEY,
        },
      },
    }),
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '..', '..', 'public-flutter'),
      exclude: ['/api/(.*)'],
    }),
    ThrottlerModule.forRoot([
      {
        ttl: 10000,
        limit: 8,
      },
    ]),
    UserModule,
    LanguageModule,
    TextContentModule,
    CategoryModule,
    ProductModule,
    OrderModule,
    PhoneModule,
    FavoriteProductModule,
    ProductOrderModule,
    DiscountModule,
    TranslationModule,
    DiscountSpecificUserModule,
    AuthModule,
    TaxModule,
    ProductUnitModule,
    UnitModule,
  ],
  controllers: [],
  providers: [
    AuthService,
    JwtService,
    LanguageService,
    AppService,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule {}
