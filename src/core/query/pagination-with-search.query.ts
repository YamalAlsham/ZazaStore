import { Transform, Type } from 'class-transformer';
import {
  IsDefined,
  IsEnum,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class PaginationWithSearch {
  @Type(() => Number)
  @IsNumber()
  @IsDefined()
  page: number;

  @Transform(({ value }) => parseInt(value))
  @IsNumber()
  @IsDefined()
  limit: number;

  @IsString()
  @IsOptional()
  search: string;

  @IsOptional()
  @IsString()
  @IsEnum(['newest', 'oldest'])
  sort: string;
}
