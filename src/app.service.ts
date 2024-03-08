import { Injectable } from '@nestjs/common';
import { LanguageService } from './modules/language/language.service';
import { InjectRepository } from '@nestjs/typeorm';
import { CategoryType } from './modules/category/entities/category-type.entity';
import { Repository } from 'typeorm';
@Injectable()
export class AppService {
  constructor(
    private readonly languageService: LanguageService,
    @InjectRepository(CategoryType)
    private readonly categoryTypeRepository: Repository<CategoryType>,
  ) {}

  async seed() {
    const en = await this.languageService.findByCode('en');
    if (!en) this.languageService.create({ code: 'en', name: 'English' });

    const de = await this.languageService.findByCode('de');
    if (!de) this.languageService.create({ code: 'de', name: 'German' });

    const ar = await this.languageService.findByCode('ar');
    if (!ar) this.languageService.create({ code: 'ar', name: 'Arabic' });

    const leaf = await this.categoryTypeRepository.findOneBy({ name: 'leaf' });
    if (!leaf) this.categoryTypeRepository.save({ name: 'leaf' });

    const node = await this.categoryTypeRepository.findOneBy({
      name: 'node',
    });
    if (!node) this.categoryTypeRepository.save({ name: 'node' });

    const unknown = await this.categoryTypeRepository.findOneBy({
      name: 'unknown',
    });
    if (!unknown) this.categoryTypeRepository.save({ name: 'unknown' });
  }
}
