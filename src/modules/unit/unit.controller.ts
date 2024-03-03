import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Inject,
  Query,
} from '@nestjs/common';
import { UnitService } from './unit.service';
import { AccessTokenGuard } from '../auth/guards/accessToken.guard';
import { IsAdminGuard } from '../auth/guards/is-admin.guard';
import { REQUEST } from '@nestjs/core';
import { Request } from 'express';
import { CreateTextContentDto } from '../text-content/dto/create-text-content.dto';
import { SecondCreateTranslationDto } from '../translation/dto/create-translation.dto';
import { TextContentService } from '../text-content/text-content.service';
import { TranslationService } from '../translation/translation.service';
import { DoesLanguageCodeForTranslationExistGuard } from '../language/guards/does-language-code-for-translation-exist.guard';
import { DoesLanguageCodeForTextContentExistGuard } from '../language/guards/does-language-code-for-textContent-exist.guard';
import { UpdateTextContentDto } from '../text-content/dto/update-text-content.dto';
import { UpdateSecondTranslationDtoList } from '../translation/dto/update-translation.dto';
import { DoesUnitExistGuard } from './guards/does-unit-exist.guard';
import { ApiTags } from '@nestjs/swagger';
import { LanguageQuery } from 'src/core/query/language.query';

@ApiTags('unit')
@Controller('unit')
export class UnitController {
  constructor(
    private readonly unitService: UnitService,
    private readonly textContentService: TextContentService,
    private readonly translationService: TranslationService,
  ) {}

  @UseGuards(
    AccessTokenGuard,
    IsAdminGuard,
    DoesLanguageCodeForTextContentExistGuard,
    DoesLanguageCodeForTranslationExistGuard,
  )
  @Post()
  async create(
    @Body('textContent') createTextContentDto: CreateTextContentDto,
    @Body('translation') createTranslationDtoList: SecondCreateTranslationDto[],
  ) {
    const createdTextContent = await this.textContentService.create(
      createTextContentDto,
    );

    await this.translationService.createMany(
      createTranslationDtoList,
      createdTextContent.id,
    );

    return this.unitService.create(createdTextContent);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard)
  @Get()
  findAll(@Query() code: LanguageQuery) {
    return this.unitService.findAll(code.language);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard, DoesUnitExistGuard)
  @Get(':id')
  findOne(@Param('id') id: string, @Query() code: LanguageQuery) {
    return this.unitService.findByCode(+id, code.language);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard, DoesUnitExistGuard)
  @Patch(':id')
  async update(
    @Param('id') id: string,
    @Body('textContent') updateTextContentDto: UpdateTextContentDto,
    @Body('translation')
    updateSecondTranslationDtoList: UpdateSecondTranslationDtoList[],
  ) {
    const unit = await this.unitService.findOne(+id);
    const textContentId = unit.textContentId;
    const updatedTextContent = await this.textContentService.update(
      +textContentId,
      updateTextContentDto,
    );

    const updatedTranslation = await this.translationService.update(
      textContentId,
      updateSecondTranslationDtoList,
    );
    return unit;
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard, DoesUnitExistGuard)
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.unitService.remove(+id);
  }
}
