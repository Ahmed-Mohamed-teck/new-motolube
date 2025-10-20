import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/global_lang_provider.dart';
import '../../../../main.dart';
import '../../../auth/provider/auth_provider.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../provider/user_cars_provider.dart';
import '../view_model/user_cars_state.dart';
import '../widget/user_car_list_item.dart';

class UserCarsListScreen extends ConsumerWidget {
  const UserCarsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final state = ref.watch(userCarsViewModelProvider);

    if (authState is AuthenticatedState && state is UserCarsInitial) {
      final customerId = authState.user.oracleId;
      if (customerId.isNotEmpty) {
        Future.microtask(
          () => ref
              .read(userCarsViewModelProvider.notifier)
              .fetchUserCars(customerId: customerId),
        );
      }
    }

    if (authState is! AuthenticatedState) {
      return Scaffold(
        body: Center(child: Text(appLang.PleaseLoginToViewYourCarsMessage)),
      );
    }

    Widget body;
    if (state is UserCarsLoading || state is UserCarsInitial) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state is UserCarsLoaded) {
      final cars = state.cars;
      if (cars.isEmpty) {
        body = Center(child: Text(appLang.noCarsFound));
      } else {
        body = ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: cars.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final car = cars[index];
            final imageUrl = car.carImages.isNotEmpty ? car.carImages.first : '';
            final model = '${car.manufacturer} ${car.modelYear}'.trim();
            final plate = car.englishPlate.join();
            final chassis = car.vinNumber;
            final heroTag = 'list-car-${car.vehicleId}';

            return CarCard(
              car: CarInfo(
                imageUrl: imageUrl,
                model: model,
                plate: plate,
                chassis: chassis,
              ),
              heroTag: heroTag,
              onTap: () {
                navigatorKey.currentState!.pushNamed(
                  'userCarDetailsScreen',
                  arguments: car,
                );
              },
            );
          },
        );
      }
    } else if (state is UserCarsError) {
      body = Center(
        child: Text(
          state.message,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    } else {
      body = const SizedBox.shrink();
    }

    return Scaffold(body: body);
  }
}
