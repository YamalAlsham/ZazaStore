import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsDefined,
  IsEnum,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class PaginationWithSearch {
  @ApiProperty({ required: true, minimum: 1, default: 1 })
  @Type(() => Number)
  @IsNumber()
  @IsDefined()
  page: number;

  @ApiProperty({ required: true, minimum: 1, default: 10 })
  @Transform(({ value }) => parseInt(value))
  @IsNumber()
  @IsDefined()
  limit: number;

  @ApiProperty({ required: false, default: '' })
  @IsString()
  @IsOptional()
  search: string;

  @IsOptional()
  @IsString()
  @IsEnum(['newest', 'oldest'])
  @ApiProperty({
    type: String,
    enum: ['newest', 'oldest'],
    required: false,
    default: 'newest',
  })
  sort: string;
}
