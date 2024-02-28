import {
  Controller,
  Get,
  Post,
  Param,
  UseGuards,
  Req,
  Query,
} from '@nestjs/common';
import { FavoriteProductService } from './favorite-product.service';
import { AccessTokenGuard } from '../auth/guards/accessToken.guard';
import { DoesProductExistGuard } from '../product/guards/does-product-exist.guard';
import { getUserId } from '../user/helper/get-user-id.helper';
import { Request } from 'express';
import { QueryFilter } from 'src/core/query/query-filter.query';

@Controller('favorite-product')
export class FavoriteProductController {
  constructor(
    private readonly favoriteProductService: FavoriteProductService,
  ) {}

  @UseGuards(AccessTokenGuard, DoesProductExistGuard)
  @Post(':id')
  create(@Param('id') productId: number, @Req() req: Request) {
    const userId = getUserId(req);
    return this.favoriteProductService.create(userId, +productId);
  }

  @UseGuards(AccessTokenGuard)
  @Get()
  async findAll(@Req() req: Request, @Query() query: QueryFilter) {
    const userId = getUserId(req);
    const favorite = await this.favoriteProductService.findOneByUser(userId);
    if (!favorite) return { translatedProducts: [], count: 0 };

    return this.favoriteProductService.findAllByUserId(userId, query, req);
  }
}
