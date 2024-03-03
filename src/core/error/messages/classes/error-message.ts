import {
  LanguageCodeEnum,
  defaultLanguage,
} from 'src/modules/language/helper/language-enum';

export class ErrorMessage {
  private translations: Record<LanguageCodeEnum, string>;

  constructor(translations: Record<LanguageCodeEnum, string>) {
    this.translations = translations;
  }

  getMessage(language: LanguageCodeEnum): string {
    return this.translations[language] || this.translations[defaultLanguage];
  }
}
