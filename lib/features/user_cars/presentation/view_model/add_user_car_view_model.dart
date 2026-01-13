import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/car_entity.dart';
import '../../domain/use_case/add_user_car_use_case.dart';
import '../../domain/use_case/update_user_car_use_case.dart';
import 'add_user_car_state.dart';

class AddUserCarViewModel extends StateNotifier<AddUserCarState> {
  final AddUserCarUseCase _addUserCarUseCase;
  final UpdateUserCarUseCase _updateUserCarUseCase;

  AddUserCarViewModel(
    this._addUserCarUseCase,
    this._updateUserCarUseCase,
  ) : super(AddUserCarInitial());

  Future<void> addCar(CarEntity car) async {
    state = AddUserCarLoading();
    try {
      await _addUserCarUseCase(car: car);
      state = AddUserCarSuccess();
    } catch (e) {
      state = AddUserCarError(e.toString());
    }
  }

  Future<void> updateCar(CarEntity car) async {
    state = AddUserCarLoading();
    try {
      await _updateUserCarUseCase(car: car);
      state = AddUserCarSuccess();
    } catch (e) {
      state = AddUserCarError(e.toString());
    }
  }

  void reset() {
    state = AddUserCarInitial();
  }
}
