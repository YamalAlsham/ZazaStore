import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { AppService } from './app.service';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.enableCors();

  const appService = app.get(AppService);
  await appService.seed();

  app.setGlobalPrefix('api');

  app.useGlobalPipes(new ValidationPipe());

  //app.useStaticAssets(join(__dirname, '..', '..', 'public-flutter'));

  //  app.useGlobalFilters(new CustomExceptionFilter());
  await app.listen(process.env.PORT || 3333);
}
bootstrap();