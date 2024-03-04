import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { AppService } from './app.service';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import express from 'express';
//import * as csurf from 'csurf';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.enableCors();

  const appService = app.get(AppService);
  await appService.seed();

  app.useGlobalPipes(new ValidationPipe());

  app.useStaticAssets(join(__dirname, '..', 'public-flutter'));
  app.use('*', express.static(join(__dirname, '..','public-flutter')));


  // app.use(csurf());
  //  app.useGlobalFilters(new CustomExceptionFilter());
  await app.listen(process.env.PORT || 3333);
}
bootstrap();
