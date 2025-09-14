import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/home/presentaion/screen/base_home_screen.dart';
import 'package:newmotorlube/features/user_cars/presentation/widget/user_car_home_item_card.dart';
import 'package:newmotorlube/main.dart';

import '../../domain/entity/car_entity.dart';
import '../../provider/user_cars_provider.dart';
import '../view_model/user_cars_state.dart';


class UserCars extends ConsumerWidget {
  const UserCars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userCarsViewModelProvider);

    // Trigger initial fetch following app's MVVM pattern
    if (state is UserCarsInitial) {
      // Schedule to avoid rebuild loops
      Future.microtask(
          () => ref.read(userCarsViewModelProvider.notifier).fetchUserCars());
    }

    Widget content;
    if (state is UserCarsLoading || state is UserCarsInitial) {
      content = Row(
        children: List.generate(2, (i) => i)
            .map((_) => const _CarSkeleton(width: 200))
            .expand((w) => [w, const SizedBox(width: 12)])
            .toList()
          ..removeLast(),
      );
    } else if (state is UserCarsLoaded) {
      final cars = state.cars;
      if (cars.isEmpty) {
        content = const _EmptyCars();
      } else {
        content = Row(
          children: cars
              .map((car) {
                final String imageUrl =
                    car.carImages.isNotEmpty ? car.carImages.first : '';
                final String model =
                    '${car.manufacturer} ${car.modelYear}'.trim();
                final String plate = car.englishPlate.join();
                final String chassis = car.vinNumber;
                final heroTag = 'car-${car.vehicleId}';

                return GestureDetector(
                  onTap: () {
                    navigatorKey.currentState!.pushNamed(
                      'userCarDetailsScreen',
                      arguments: CarEntity(
                        vehicleId: car.vehicleId,
                        mileage: car.mileage,
                        arabicPlate: car.arabicPlate,
                        englishPlate: car.englishPlate,
                        carModel: car.carModel,
                        manufacturer: car.manufacturer,
                        modelYear: car.modelYear,
                        carImages: car.carImages,
                        vinNumber: car.vinNumber,
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    child: HomeCarOutlinedCard(
                      imageUrl: imageUrl,
                      model: model,
                      plate: plate,
                      chassis: chassis,
                      onBook: () {
                        ref
                            .read(currentNavBottomIndexProvider.notifier)
                            .state = 2;
                      },
                      heroTag: heroTag,
                      key: ValueKey(heroTag),
                    ),
                  ),
                );
              })
              .expand((w) => [w, const SizedBox(width: 12)])
              .toList()
            ..removeLast(),
        );
      }
    } else if (state is UserCarsError) {
      content = Text(
        state.message,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.error),
      );
    } else {
      content = const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: content,
    );
  }
}

class _CarSkeleton extends StatelessWidget {
  const _CarSkeleton({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: width * 9 / 16,
              color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: width * 0.6,
                    color:
                        theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: width * 0.5,
                    color:
                        theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: width * 0.4,
                    color:
                        theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EmptyCars extends StatelessWidget {
  const _EmptyCars();

  @override
  Widget build(BuildContext context) {
    return Text(
      'No cars found',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
