import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Query,
  Param,
  Delete,
  UseGuards,
  Req,
} from '@nestjs/common';
import { DiscountService } from './discount.service';
import { CreateDiscountDto } from './dto/create-discount.dto';
import { UpdateDiscountDto } from './dto/update-discount.dto';
import { AccessTokenGuard } from '../auth/guards/accessToken.guard';
import { IsAdminGuard } from '../auth/guards/is-admin.guard';
import { AreProductsExistGuard } from '../product/guards/are-products-exist.guard';
import { QueryFilter } from 'src/core/query/query-filter.query';
import { DoesDiscountExistGuard } from './guards/does-discount-exist.guard';
import { Request } from 'express';

@Controller('discount')
export class DiscountController {
  constructor(private readonly discountService: DiscountService) {}

  @UseGuards(AccessTokenGuard, IsAdminGuard, AreProductsExistGuard)
  @Post()
  create(
    @Body('createDiscountDtoList') createDiscountDtoList: CreateDiscountDto[],
  ) {
    return this.discountService.create(createDiscountDtoList);
  }

  @UseGuards(AccessTokenGuard)
  @Get()
  findAll(@Query() query: QueryFilter, @Req() req: Request) {
    return this.discountService.findAll(query, req);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard, DoesDiscountExistGuard)
  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateDiscountDto: UpdateDiscountDto,
  ) {
    return this.discountService.update(+id, updateDiscountDto);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard, DoesDiscountExistGuard)
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.discountService.remove(+id);
  }
}
