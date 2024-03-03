part of 'tax&unit_cubit.dart';

@immutable
abstract class TaxUnitState {}

class TaxUnitInitial extends TaxUnitState {}



///////////////////////////////////////////////////////
//Tax
class ClearDataTaxState extends TaxUnitState {}

class AddTaxLoadingState extends TaxUnitState {}

class AddTaxSuccessState extends TaxUnitState {}

class AddTaxErrorState extends TaxUnitState {
  final ErrorModel errorModel;

  AddTaxErrorState(this.errorModel);
}


class DeleteTaxLoadingState extends TaxUnitState {}

class DeleteTaxSuccessState extends TaxUnitState {}

class DeleteTaxErrorState extends TaxUnitState {
  final ErrorModel errorModel;

  DeleteTaxErrorState(this.errorModel);
}


class GetTaxLoadingState extends TaxUnitState {}

class GetTaxSuccessState extends TaxUnitState {}

class GetTaxErrorState extends TaxUnitState {
  final ErrorModel errorModel;

  GetTaxErrorState(this.errorModel);
}


///////////////////////////////////////////////////////////////////////////
//Unit

class ClearDataUnitState extends TaxUnitState {}

class AddUnitLoadingState extends TaxUnitState {}

class AddUnitSuccessState extends TaxUnitState {}

class AddUnitErrorState extends TaxUnitState {
  final ErrorModel errorModel;

  AddUnitErrorState(this.errorModel);
}


class DeleteUnitLoadingState extends TaxUnitState {}

class DeleteUnitSuccessState extends TaxUnitState {}

class DeleteUnitErrorState extends TaxUnitState {
  final ErrorModel errorModel;

  DeleteUnitErrorState(this.errorModel);
}


class GetUnitLoadingState extends TaxUnitState {}

class GetUnitSuccessState extends TaxUnitState {}

class GetUnitErrorState extends TaxUnitState {
  final ErrorModel errorModel;

  GetUnitErrorState(this.errorModel);
}




