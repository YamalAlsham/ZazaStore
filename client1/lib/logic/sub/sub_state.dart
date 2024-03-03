part of 'sub_cubit.dart';

@immutable
abstract class SubState {}

class SubInitial extends SubState {}

class PickImageSub extends SubState{}

class CreatePhotoSubLoadingState extends SubState{}

class CreatePhotoSubSuccessState extends SubState{}

class CreatePhotoSubErrorState extends SubState{
  final PhotoModelCat createPhotoModel;

  CreatePhotoSubErrorState(this.createPhotoModel);
}

class ClearDataSubState extends SubState{}

class CreateCatSubLoadingState extends SubState{}

class CreateCatSubSuccessState extends SubState {
  final CreateCatModel createCatModel;

  CreateCatSubSuccessState(this.createCatModel);

}
class CreateCatSubErrorState extends SubState {}



class ChooseTypeState extends SubState {}


class GetChildrenLoadingState extends SubState {}

class GetChildrenSuccessState extends SubState {}

class GetChildrenErrorState extends SubState {
  final ErrorModel errorModel;

  GetChildrenErrorState(this.errorModel);
}




class DeleteSubOneCategoryLoadingState extends SubState {}

class DeleteSubOneCategorySuccessState extends SubState {}

class DeleteSubOneCategoryErrorState extends SubState {}



class DeleteOneProductFromSubLoadingState extends SubState {}

class DeleteOneProductFromSubSuccessState extends SubState {}

class DeleteOneProductFromSubErrorState extends SubState {}
