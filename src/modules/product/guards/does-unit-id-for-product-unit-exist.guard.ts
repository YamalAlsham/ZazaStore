import {
  Injectable,
  CanActivate,
  ExecutionContext,
  BadRequestException,
} from '@nestjs/common';
import { In, Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Unit } from 'src/modules/unit/entities/unit.entity';

@Injectable()
export class DoesUnitIdForProductUnitExistGuard implements CanActivate {
  constructor(
    @InjectRepository(Unit)
    private readonly unitRepository: Repository<Unit>,
  ) {}
  async canActivate(context: ExecutionContext) {
    const ctx = context.switchToHttp();
    const request = ctx.getRequest();

    let units = request.body.productUnit;
    for (const unit of units) {
      if (
        !(await this.unitRepository.findOneBy({
          id: unit.unitId,
          isDeleted: false,
        }))
      )
        throw new BadRequestException('Unit does not exist');
    }

    return true;
  }
}
