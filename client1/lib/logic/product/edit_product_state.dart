part of 'edit_product_cubit.dart';

@immutable
abstract class EditProductState {}

class EditProductInitial extends EditProductState {}


class GetAllProductUnitsInfoLoadingState extends EditProductState {}

class GetAllProductUnitsInfoSuccessState extends EditProductState {}

class GetAllProductUnitsInfoErrorState extends EditProductState {
  final ErrorModel errorModel;

  GetAllProductUnitsInfoErrorState(this.errorModel);
}


class UpdateQuantityProductUnitLoadingState extends EditProductState {}

class UpdateQuantityProductUnitSuccessState extends EditProductState {}

class UpdateQuantityProductUnitErrorState extends EditProductState {
  final ErrorModel errorModel;

  UpdateQuantityProductUnitErrorState(this.errorModel);
}


class UpdateComplexProductUnitLoadingState extends EditProductState {}

class UpdateComplexProductUnitSuccessState extends EditProductState {}

class UpdateComplexProductUnitErrorState extends EditProductState {
  final ErrorModel errorModel;

  UpdateComplexProductUnitErrorState(this.errorModel);
}

////////////////////////////////////////////////////////////////////////////////

class DeleteProductUnitLoadingState extends EditProductState {}

class DeleteProductUnitSuccessState extends EditProductState {}

class DeleteProductUnitErrorState extends EditProductState {
  final ErrorModel errorModel;

  DeleteProductUnitErrorState(this.errorModel);
}



class CreateProductUnitLoadingState extends EditProductState {}

class CreateProductUnitSuccessState extends EditProductState {}

class CreateProductUnitErrorState extends EditProductState {
  final ErrorModel errorModel;

  CreateProductUnitErrorState(this.errorModel);
}


class GetUnitsForProductLoadingState extends EditProductState {}

class GetUnitsForProductSuccessState extends EditProductState {}

class GetUnitsForProductErrorState extends EditProductState {
  final ErrorModel errorModel;

  GetUnitsForProductErrorState(this.errorModel);
}





class ChangeUnitNameValue extends EditProductState {}

class ClearData extends EditProductState {}