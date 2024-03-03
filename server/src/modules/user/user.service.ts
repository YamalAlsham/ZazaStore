import { Injectable, ForbiddenException } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Repository } from 'typeorm';
import { PaginationWithSearch } from 'src/core/query/pagination-with-search.query';
import { getOrderUserByCondition } from 'src/core/helpers/sort.helper';
import { UserResetPassword } from './entities/user-reset-password.entity';
import * as argon2 from 'argon2';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(UserResetPassword)
    private readonly userResetPasswordRepository: Repository<UserResetPassword>,
  ) {}
  create(createUserDto: CreateUserDto) {
    const user = this.userRepository.create(createUserDto);
    return this.userRepository.save(user);
  }

  async findAll(query: PaginationWithSearch) {
    if (!query.search) query.search = '';

    const qb = this.userRepository.createQueryBuilder('user');
    qb.where('user.userName LIKE :search', { search: `%${query.search}%` })
      .andWhere('user.userName != :username', { username: 'admin' })
      .orderBy(getOrderUserByCondition(query.sort))
      .skip((query.page - 1) * query.limit)
      .take(query.limit);

    const [users, count] = await qb.getManyAndCount();

    return {
      count,
      users,
    };
  }

  findOne(id: number) {
    return this.userRepository.findOne({
      where: { id },
      relations: {
        phones: true,
      },
    });
  }

  async remove(id: number) {
    const user = await this.findById(id);
    if (user.userName === 'admin')
      throw new ForbiddenException('Cannot remove the admin');
    return this.userRepository.remove(user);
  }

  public findByUserName(userName: string) {
    return this.userRepository.findOneBy({ userName });
  }

  public findById(userId: number) {
    return this.userRepository.findOneBy({ id: userId });
  }

  public profile(userId: number) {
    return this.userRepository.findOne({
      where: { id: userId },
      relations: {
        phones: true,
      },
    });
  }

  public findByIdWithRefreshToken(userId: number) {
    return this.userRepository.findOne({
      where: { id: userId },
      select: {
        refreshToken: true,
        email: true,
        name: true,
        id: true,
        userName: true,
      },
    });
  }

  async generateResetToken(email: string): Promise<string> {
    const user = await this.findByEmail(email);
    const token = Math.floor(1000 + Math.random() * 9000).toString();
    const hashedToken = await argon2.hash(token);
    const expires = new Date();
    expires.setHours(expires.getHours() + 1);

    await this.userResetPasswordRepository.save({
      userId: user.id,
      resetToken: hashedToken,
      resetTokenExpire: expires,
    });

    return token;
  }

  public findByEmail(email: string) {
    return this.userRepository.findOneBy({ email });
  }

  public findByResetToken(token: string) {
    return this.userRepository.findOne({
      relations: {
        userResetPassword: true,
      },
      where: {
        userResetPassword: {
          resetToken: token,
        },
      },
    });
  }

  async updateRefreshToken(userId: number, hashedRefreshToken: string) {
    const user = await this.findById(userId);
    user.refreshToken = hashedRefreshToken;

    await this.userRepository.save(user);
  }

  async resetPassword(user: User, newPassword: string): Promise<User> {
    user.password = await argon2.hash(newPassword);
    return this.userRepository.save(user);
  }
}
