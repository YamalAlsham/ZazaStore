import { OrderByCondition } from 'typeorm';
export function getOrderByCondition(sort: string): OrderByCondition {
  switch (sort) {
    case 'newest':
      return { createdAt: 'DESC' };
    case 'oldest':
      return { createdAt: 'ASC' };
    default:
      return {};
  }
}
export function getOrderProductByCondition(sort: string): OrderByCondition {
  switch (sort) {
    case 'newest':
      return { 'product.id': 'DESC' };
    case 'oldest':
      return { 'product.id': 'ASC' };
    default:
      return {};
  }
}

export function getOrderUserByCondition(sort: string): OrderByCondition {
  switch (sort) {
    case 'newest':
      return { 'user.createdAt': 'DESC' };
    case 'oldest':
      return { 'user.createdAt': 'ASC' };
    default:
      return {};
  }
}
