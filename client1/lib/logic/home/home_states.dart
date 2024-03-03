import 'package:zaza_dashboard/models/create/createCat_model.dart';
import 'package:zaza_dashboard/models/create/createPro_model.dart';
import 'package:zaza_dashboard/models/edit/editCat_model.dart';
import 'package:zaza_dashboard/models/create/photo_model.dart';
import 'package:zaza_dashboard/models/edit/edit_simple_pro_model.dart';
import 'package:zaza_dashboard/models/error_model.dart';

abstract class HomeState{}

class init_Home extends HomeState{}

class PickImage extends HomeState{}

class CreatePhotoLoadingState extends HomeState{}

class CreatePhotoSuccessState extends HomeState{}

class CreatePhotoErrorState extends HomeState{
  final PhotoModelCat createPhotoModel;

  CreatePhotoErrorState(this.createPhotoModel);
}

class ClearDataState extends HomeState{}

class CreateCatLoadingState extends HomeState{}

class CreateCatSuccessState extends HomeState {
  final CreateCatModel createCatModel;

  CreateCatSuccessState(this.createCatModel);

}
class CreateCatErrorState extends HomeState {}




class GetMainCategoriesLoadingState extends HomeState {}

class GetMainCategoriesSuccessState extends HomeState {}

class GetMainCategoriesErrorState extends HomeState {}




class DeleteOneCategoryLoadingState extends HomeState {}

class DeleteOneCategorySuccessState extends HomeState {}

class DeleteOneCategoryErrorState extends HomeState {}



class EditDataCategoryLoadingState extends HomeState {}

class EditDataCategorySuccessState extends HomeState {}

class EditDataCategoryErrorState extends HomeState {}



class EditedCategoryLoadingState extends HomeState {}

class EditedCategorySuccessState extends HomeState {
  final EditedCatModel editedCatModel;

  EditedCategorySuccessState(this.editedCatModel);
}

class EditedCategoryErrorState extends HomeState {}



class EditedPhotoCategoryLoadingState extends HomeState {}

class EditedPhotoCategorySuccessState extends HomeState {}

class EditedPhotoCategoryErrorState extends HomeState {
  final PhotoModelCat editedPhotoModel;

  EditedPhotoCategoryErrorState(this.editedPhotoModel);
}






class CreateDiscountForProductLoadingState extends HomeState {}

class CreateDiscountForProductSuccessState extends HomeState {}

class CreateDiscountForProductErrorState extends HomeState {}


class DeleteDiscountForProductLoadingState extends HomeState {}

class DeleteDiscountForProductSuccessState extends HomeState {}

class DeleteDiscountForProductErrorState extends HomeState {}




class GetTaxForProductsLoadingState extends HomeState{}

class GetTaxForProductsSuccessState extends HomeState {}

class GetTaxForProductsErrorState extends HomeState {
  final ErrorModel errorModel;

  GetTaxForProductsErrorState(this.errorModel);
}




class GetTaxForOneProductLoadingState extends HomeState{}

class GetTaxForOneProductSuccessState extends HomeState {}

class GetTaxForOneProductErrorState extends HomeState {
  final ErrorModel errorModel;

  GetTaxForOneProductErrorState(this.errorModel);
}




class UpdateTaxForOneProductLoadingState extends HomeState{}

class UpdateTaxForOneProductSuccessState extends HomeState {}

class UpdateTaxForOneProductErrorState extends HomeState {
  final ErrorModel errorModel;

  UpdateTaxForOneProductErrorState(this.errorModel);
}



class GetSimpleDataProductLoadingState extends HomeState{}

class GetSimpleDataProductSuccessState extends HomeState {}

class GetSimpleDataProductErrorState extends HomeState {
  final ErrorModel errorModel;

  GetSimpleDataProductErrorState(this.errorModel);
}




class UpdateSimpleDataProductLoadingState extends HomeState{}

class UpdateSimpleDataProductSuccessState extends HomeState {
  final EditedProModel editedProModel;

  UpdateSimpleDataProductSuccessState(this.editedProModel);
}

class UpdateSimpleDataProductErrorState extends HomeState {
  final ErrorModel errorModel;

  UpdateSimpleDataProductErrorState(this.errorModel);
}


class EditProductPhotoLoadingState extends HomeState {}

class EditProductPhotoSuccessState extends HomeState {}

class EditProductPhotoErrorState extends HomeState {
  final ErrorModel errorModel;

  EditProductPhotoErrorState(this.errorModel);
}


class ChangeEditedTaxId extends HomeState {}