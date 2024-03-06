import { FileInterceptor } from '@nestjs/platform-express';
import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Query,
  UseInterceptors,
  UploadedFile,
  ParseFilePipe,
  MaxFileSizeValidator,
  FileTypeValidator,
  NotFoundException,
  Req,
} from '@nestjs/common';
import { CategoryService } from './category.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { DoesParentCategorySafeForCategoriesGuard } from './guards/does-parent-category-safe-for-categories.guard';
import { TranslationService } from '../translation/translation.service';
import { TextContentService } from '../text-content/text-content.service';
import { DoesLanguageCodeForTextContentExistGuard } from '../language/guards/does-language-code-for-textContent-exist.guard';
import { DoesLanguageCodeForTranslationExistGuard } from '../language/guards/does-language-code-for-translation-exist.guard';
import { InjectRepository } from '@nestjs/typeorm';
import { Category } from './entities/category.entity';
import { Repository } from 'typeorm';
import { CreateTextContentDto } from '../text-content/dto/create-text-content.dto';
import { SecondCreateTranslationDto } from '../translation/dto/create-translation.dto';
import { AccessTokenGuard } from '../auth/guards/accessToken.guard';
import { IsAdminGuard } from '../auth/guards/is-admin.guard';
import { DoesCategoryExistGuard } from './guards/does-category-exist.guard';
import { UpdateTextContentDto } from '../text-content/dto/update-text-content.dto';
import { UpdateSecondTranslationDtoList } from '../translation/dto/update-translation.dto';
import { PaginationWithLanguage } from 'src/core/query/pagination-with-language.query';
import { Request } from 'express';
import { UploadService } from '../upload/upload.service';
import { Throttle } from '@nestjs/throttler';

@Controller('category')
export class CategoryController {
  constructor(
    private readonly categoryService: CategoryService,
    private readonly textContentService: TextContentService,
    private readonly translationService: TranslationService,
    private readonly uploadService: UploadService,
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  @UseGuards(
    AccessTokenGuard,
    IsAdminGuard,
    DoesParentCategorySafeForCategoriesGuard,
    DoesLanguageCodeForTextContentExistGuard,
    DoesLanguageCodeForTranslationExistGuard,
  )
  @Post()
  async create(
    @Body() createCategoryDto: CreateCategoryDto,
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
    return this.categoryService.create(
      createCategoryDto.parentCategoryId,
      createdTextContent,
    );
  }

  @UseGuards(AccessTokenGuard)
  @Get()
  findAllFathers(@Query() query: PaginationWithLanguage) {
    return this.categoryService.findAllFathers(query);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard)
  @Get('acceptProducts')
  findAllThatAcceptProducts(@Query('language') language: string) {
    return this.categoryService.findAllThatAcceptProducts(language);
  }

  @UseGuards(AccessTokenGuard, DoesCategoryExistGuard)
  @Get(':id/findWithRelation')
  findOneWithRelations(@Param('id') id: string) {
    return this.categoryService.findOneWithTextContentAndTranslations(+id);
  }

  @UseGuards(AccessTokenGuard, DoesCategoryExistGuard)
  @Get(':id')
  findOne(
    @Param('id') id: string,
    @Query() query: PaginationWithLanguage,
    @Req() req: Request,
  ) {
    return this.categoryService.findOneWithChildren(+id, query, req);
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard, DoesCategoryExistGuard)
  @Patch(':id')
  async update(
    @Param('id') id: string,
    @Body('textContent') updateTextContentDto: UpdateTextContentDto,
    @Body('translation')
    updateSecondTranslationDtoList: UpdateSecondTranslationDtoList[],
  ) {
    const category = await this.categoryService.findOne(+id);

    const textContentId = category.textContentId;
    const updatedTextContent = await this.textContentService.update(
      +textContentId,
      updateTextContentDto,
    );

    const updatedTranslation = await this.translationService.update(
      textContentId,
      updateSecondTranslationDtoList,
    );

    return { category, updatedTextContent, updatedTranslation };
  }

  @UseGuards(AccessTokenGuard, IsAdminGuard, DoesCategoryExistGuard)
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.categoryService.remove(+id);
  }

  @Throttle({ default: { limit: 4, ttl: 10000 } })
  @UseGuards(AccessTokenGuard, IsAdminGuard)
  @Post('image')
  @UseInterceptors(FileInterceptor('image'))
  async createImage(
    @Body('categoryId') categoryId: string,
    @UploadedFile(
      new ParseFilePipe({
        validators: [
          new MaxFileSizeValidator({ maxSize: 10000000 }),
          new FileTypeValidator({ fileType: '.(png|jpeg|jpg)' }),
        ],
      }),
    )
    path: Express.Multer.File,
  ) {
    const category = await this.categoryService.findOne(+categoryId);
    if (!category) throw new NotFoundException();

    const { originalname, buffer } = path;
    category.image = originalname;

    await this.categoryRepository.save(category);

    await this.uploadService.upload(originalname, buffer);

    return category;
  }
}
