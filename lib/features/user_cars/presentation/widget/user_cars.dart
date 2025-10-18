import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
import 'package:newmotorlube/features/auth/presentation/view_model/auth_state.dart';
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
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next is UnauthenticatedState) {
        ref.invalidate(userCarsViewModelProvider);
      }
    });

    final authState = ref.watch(authViewModelProvider);

    // Provide a friendly prompt when the user is logged out
    if (authState is UnauthenticatedState) {
      return  EmptyCarsCard(
        onTap: () {
          ref.read(currentNavBottomIndexProvider.notifier).state = 4;
        },
      );
    }

    final state = ref.watch(userCarsViewModelProvider);

    // Only attempt to fetch data when authenticated
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

    Widget content;
    if (state is UserCarsLoading || state is UserCarsInitial) {
      content = Row(
        children:
            List.generate(2, (i) => i)
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
          children:
              cars
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
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
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
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: width * 0.5,
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: width * 0.4,
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                ],
              ),
            ),
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
    return Text('No cars found', style: Theme.of(context).textTheme.bodyMedium);
  }
}



class EmptyCarsCard extends StatelessWidget {
   EmptyCarsCard({
    super.key,
    required this.onTap,
    this.icon = Icons.directions_car_filled_rounded,
    this.maxWidth = 520,
  });

  final VoidCallback onTap;
  final IconData icon;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon inside a light circle
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  appLang.noCarsFound,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                // Message
                Text(
                  appLang.PleaseLoginToViewYourCarsMessage,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 24),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.login_rounded, color: Colors.white),
                    label: Text(
                      appLang.logInToContinue,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



