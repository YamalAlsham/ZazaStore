part of 'create_product_cubit.dart';

@immutable
abstract class CreateProductState {}

class CreateProductInitial extends CreateProductState {}

class PickImage extends CreateProductState{}

class ClearDataState extends CreateProductState{}

class CreateProductLoadingState extends CreateProductState{}

class CreateProductSuccessState extends CreateProductState {
  final CreateProModel createProModel;

  CreateProductSuccessState(this.createProModel);
}
class CreateProductErrorState extends CreateProductState
{
  final ErrorModel errorModel;

  CreateProductErrorState(this.errorModel);
}

class CreatePhotoLoadingState extends CreateProductState{}

class CreatePhotoProSuccessState extends CreateProductState{}

class CreatePhotoProErrorState extends CreateProductState{
  final PhotoModelCat createPhotoModel;

  CreatePhotoProErrorState(this.createPhotoModel);
}



class CreateProLoadingState extends CreateProductState{}

class CreateProSuccessState extends CreateProductState {
  final CreateProModel createCatModel;

  CreateProSuccessState(this.createCatModel);

}
class CreateProErrorState extends CreateProductState {
  final ErrorModel errorModel;

  CreateProErrorState(this.errorModel);
}





class GetCatForProductsLoadingState extends CreateProductState{}

class GetCatForProductsSuccessState extends CreateProductState {}

class GetCatForProductsErrorState extends CreateProductState {
  final ErrorModel errorModel;

  GetCatForProductsErrorState(this.errorModel);
}





class GetTaxForProductsLoadingState extends CreateProductState{}

class GetTaxForProductsSuccessState extends CreateProductState {}

class GetTaxForProductsErrorState extends CreateProductState {
  final ErrorModel errorModel;

  GetTaxForProductsErrorState(this.errorModel);
}



class GetUnitForProductsLoadingState extends CreateProductState{}

class GetUnitForProductsSuccessState extends CreateProductState {}

class GetUnitForProductsErrorState extends CreateProductState {
  final ErrorModel errorModel;

  GetUnitForProductsErrorState(this.errorModel);
}





class ChangeTaxIdDropDown extends CreateProductState {}

class ChangeCategoryIdDropDown extends CreateProductState {}

class ChangeUnitIdDropDown extends CreateProductState {}




class AddOtherUnitsState extends CreateProductState {}

class RemoveOtherUnitsState extends CreateProductState {}


