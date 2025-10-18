import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/use_case/get_user_cars_use_case.dart';
import 'user_cars_state.dart';

class UserCarsViewModel extends StateNotifier<UserCarsState> {
  final GetUserCarsUseCase _getUserCarsUseCase;

  UserCarsViewModel(this._getUserCarsUseCase) : super(const UserCarsInitial());

  Future<void> fetchUserCars({String? customerId}) async {
    if (state is UserCarsLoading) {
      return;
    }

    state = const UserCarsLoading();
    try {
      final sanitizedCustomerId =
          (customerId != null && customerId.trim().isNotEmpty)
              ? customerId.trim()
              : null;
      final cars =
          await _getUserCarsUseCase(customerId: sanitizedCustomerId);
      state = UserCarsLoaded(cars);
    } catch (e) {
      state = UserCarsError(e.toString());
    }
  }
}
