import { Transform, Type } from 'class-transformer';
import { IsDefined, IsEnum, IsNumber, IsString } from 'class-validator';

export class PaginationWithLanguage {
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
}
