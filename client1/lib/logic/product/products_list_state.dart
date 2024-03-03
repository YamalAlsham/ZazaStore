part of 'products_list_cubit.dart';

@immutable
abstract class ProductsListState {}

class ProductsListInitial extends ProductsListState {}


class GetAllProductsLoadingState extends ProductsListState {}

class GetAllProductsSuccessState extends ProductsListState {}

class GetAllProductsErrorState extends ProductsListState {}




class DeleteOneProductLoadingState extends ProductsListState {}

class DeleteOneProductSuccessState extends ProductsListState {}

class DeleteOneProductErrorState extends ProductsListState {}


