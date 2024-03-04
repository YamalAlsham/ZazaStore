import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { AppService } from './app.service';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
const express = require('express');
//import * as csurf from 'csurf';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.enableCors();

  const appService = app.get(AppService);
  await appService.seed();

  app.useGlobalPipes(new ValidationPipe());

  // Serve static files using NestJS method
  app.useStaticAssets(join(__dirname, '..', '..', 'public-flutter'));

  // All routes that don't match static files will serve the Flutter app
  app.use((req, res, next) => {
    res.sendFile(join(__dirname, '..','..', 'public-flutter', 'index.html'));
  });

  app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });


  // app.use(csurf());
  //  app.useGlobalFilters(new CustomExceptionFilter());
  await app.listen(process.env.PORT || 3333);
}
bootstrap();
