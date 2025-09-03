import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/user_cars/domain/use_case/get_manufacturers_use_case.dart';

import 'manufacturers_state.dart';

class ManufacturersViewModel extends StateNotifier<ManufacturersState> {
  final GetManufacturersUseCase getManufacturersUseCase;
  String? selectedManufacturerId;

  ManufacturersViewModel(
    this.getManufacturersUseCase,
      ) : super(ManufacturersInitial());

  Future<void> fetchManufacturers() async {
    state = ManufacturersLoading();
    try {
      final manufacturers = await getManufacturersUseCase();
      state = ManufacturersLoaded(manufacturers);
    } catch (e) {
      state = ManufacturersError(e.toString());
    }
  }

  void selectManufacturer(String manufacturerId) {
    selectedManufacturerId = manufacturerId;
  }
}