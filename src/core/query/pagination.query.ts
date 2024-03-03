import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsDefined,
  IsEnum,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class Pagination {
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
