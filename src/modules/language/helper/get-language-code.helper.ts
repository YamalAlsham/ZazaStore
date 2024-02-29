import { Request } from 'express';
import { LanguageCodeEnum } from './language-enum';

export function getLanguageFromRequest(
  request: Request,
): LanguageCodeEnum | null {
  const language = request.query.language as LanguageCodeEnum | undefined;
  return language || null;
}
