import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppCubit<StateType extends AppCubitState> extends Cubit<StateType> {
  AppCubit(super.initialState);

  @override
  emit(StateType state, { bool isLoading = false }) {
    var clonedState = state.clone() as StateType;
    clonedState.isLoading = isLoading;
    super.emit(clonedState);
  }
}

abstract class AppCubitState {
  bool isLoading;

  AppCubitState(this.isLoading);

  AppCubitState clone();
}