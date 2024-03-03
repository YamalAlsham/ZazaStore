import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'discount_specific_user_state.dart';

class DiscountSpecificUserCubit extends Cubit<DiscountSpecificUserState> {
  DiscountSpecificUserCubit() : super(DiscountSpecificUserInitial());

  static DiscountSpecificUserCubit get(context) => BlocProvider.of(context);



}
