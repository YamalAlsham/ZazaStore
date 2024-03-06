import { Injectable } from '@nestjs/common';
import { CreateTranslationDto } from './dto/create-translation.dto';
import { UpdateSecondTranslationDtoList } from './dto/update-translation.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Translation } from './entities/translation.entity';
import { Repository } from 'typeorm';
import { TextContent } from '../text-content/entities/text-content.entity';

@Injectable()
export class TranslationService {
  constructor(
    @InjectRepository(Translation)
    private readonly translationRepository: Repository<Translation>,
  ) {}
  create(createTranslationDto: CreateTranslationDto) {
    const translation = this.translationRepository.create(createTranslationDto);
    return this.translationRepository.save(translation);
  }

  async createMany(
    createTranslationDto: CreateTranslationDto[],
    textContentId: number,
  ) {
    const createdTranslations = [];

    for (const translationDto of createTranslationDto) {
      const translation = this.translationRepository.create({
        textContentId,
        ...translationDto,
      });
      const createdTranslation = await this.translationRepository.save(
        translation,
      );
      createdTranslations.push(createdTranslation);
    }
    return createdTranslations;
  }

  findByTextContentId(id: number) {
    return this.translationRepository.findBy({ textContentId: id });
  }

  async update(
    id: number,
    updateSecondTranslationDtoList: UpdateSecondTranslationDtoList[],
  ) {
    // Assuming findByTextContentId returns an array of existing translations
    const existingTranslations = await this.findByTextContentId(id);

    // Separate existing translations by code for easy lookup
    const existingTranslationsMap = new Map(
      existingTranslations.map((t) => [t.code, t]),
    );

    const translationsToUpdate = [];
    const translationsToCreate = [];
    const updatedTranslations = []; // List to hold updated translations

    for (const updateTranslation of updateSecondTranslationDtoList) {
      const { code, translation: updatedTranslation } = updateTranslation;

      if (existingTranslationsMap.has(code)) {
        // Update existing translation
        const existingTranslation = existingTranslationsMap.get(code);
        existingTranslation.translation = updatedTranslation;
        translationsToUpdate.push(existingTranslation);
        updatedTranslations.push(existingTranslation); // Add to updated translations list
      } else {
        // Create new translation
        const newTranslation = this.translationRepository.create({
          code,
          textContentId: id,
          translation: updatedTranslation,
        });
        translationsToCreate.push(newTranslation);
        updatedTranslations.push(newTranslation); // Add to updated translations list
      }
    }

    // Save updated translations
    await this.translationRepository.save(translationsToUpdate);

    // Save new translations
    await this.translationRepository.save(translationsToCreate);

    return updatedTranslations; // Return the list of updated translations
  }
}
