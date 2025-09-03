import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/user_cars/domain/use_case/get_car_brands_model_use_case.dart';
import 'package:newmotorlube/features/user_cars/presentation/view_model/car_brands_state.dart';



class CarBrandsViewModel extends StateNotifier<CarBrandsState> {
  final GetCarBrandsModelUseCase getCarBrandsModelUseCase;

  CarBrandsViewModel(
      this.getCarBrandsModelUseCase,
      ) : super(CarBrandsInitial());

  Future<void> fetCarBrands({required String carModelId}) async {
    state = CarBrandsLoading();
    try {
      final carBrands = await getCarBrandsModelUseCase(carModelId:carModelId);
      state = CarBrandsLoaded(carBrands);
    } catch (e) {
      state = CarBrandsError(e.toString());
    }
  }
}