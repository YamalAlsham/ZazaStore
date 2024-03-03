import { Transform, Type } from 'class-transformer';
import {
  IsDefined,
  IsEnum,
  IsNumber,
  IsOptional,
  IsString,
} from 'class-validator';

export class QueryFilter {
  @Type(() => Number)
  @IsNumber()
  @IsDefined()
  page: number;

  @Transform(({ value }) => parseInt(value))
  @IsNumber()
  @IsDefined()
  limit: number;

  @IsString()
  @IsDefined()
  @IsEnum(['en', 'de', 'ar'])
  language: string;

  @IsString()
  @IsOptional()
  search: string;

  @IsString()
  @IsOptional()
  searchByName: string;

  @IsOptional()
  @IsString()
  @IsEnum(['newest', 'oldest'])
  sort: string;
}
