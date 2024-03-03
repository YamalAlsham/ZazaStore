import { config } from 'dotenv';
import { DataSource, DataSourceOptions } from 'typeorm';
import { SnakeNamingStrategy } from 'typeorm-naming-strategies';

config();

export const dataSourceOptions: DataSourceOptions = {
  type: 'mysql',
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  username: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME_DEVELOPMENT,
  url: process.env.MYSQL_URL,
  entities: ['dist/**/*.entity.js'],
  synchronize: true,
  logging: false,
  namingStrategy: new SnakeNamingStrategy(),
};

new DataSource(dataSourceOptions);
