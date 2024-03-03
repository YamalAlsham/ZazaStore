import { IsDefined, IsEnum, IsString } from 'class-validator';
export class LanguageQuery {
  @IsString()
  @IsDefined()
  @IsEnum(['en', 'de', 'ar'])
  language: string;
}
