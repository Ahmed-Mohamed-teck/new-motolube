import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/features/auth/presentation/view_model/auth_state.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
import 'package:newmotorlube/features/home/provider/home_provider.dart';
import 'package:newmotorlube/features/upcoming_service/presentation/widget/upcoming_service_section.dart';
import '../../../../main.dart';
import '../../../promotions/presentation/widget/promotions.dart';
import '../../../user_cars/provider/user_cars_provider.dart';
import '../../../user_cars/presentation/widget/user_cars.dart';
import '../widget/home_service_grid.dart';
import '../widget/title_with_sub_title.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final authState = ref.watch(authViewModelProvider);
        final isAuthenticated = authState is AuthenticatedState;
        final promotionImageUrls = ref
            .watch(promotionsSliderImageUrlsProvider)
            .maybeWhen(
              data: (imageUrls) => imageUrls,
              orElse: () => const <String>[],
            );

        Widget? addCarAction;
        VoidCallback? onYourCarsTap;
        if (isAuthenticated) {
          addCarAction = IconButton(
            onPressed: () async {
              final result = await navigatorKey.currentState!.pushNamed(
                'addNewCarScreen',
              );
              if (result == true) {
                ref.invalidate(userCarsViewModelProvider);
              }
            },
            icon: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          );
          onYourCarsTap = () {
            Navigator.of(
              navigatorKey.currentContext!,
            ).pushNamed('ourServicesScreen');
          };
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Promotions(imageUrls: promotionImageUrls),
              const SizedBox(height: 16),
              TitleWithSubTitle(
                title: appLang.ourServices,
                onSubTitleTap: () {
                  Navigator.of(
                    navigatorKey.currentContext!,
                  ).pushNamed('ourServicesScreen');
                },
              ),
              HomeServiceGrid(isAuthenticated: isAuthenticated),

              const SizedBox(height: 16),
              TitleWithSubTitle(
                withSubTitle: true,
                title: appLang.upcomingService,
                subTitle: Text(
                  appLang.allButtonLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onSubTitleTap: () {
                  Navigator.of(
                    navigatorKey.currentContext!,
                  ).pushNamed('customerAppointmentsScreen');
                },
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: UpcomingServiceSection(),
              ),
              const SizedBox(height: 16),
              TitleWithSubTitle(
                withSubTitle: isAuthenticated,
                title: appLang.yourCars,
                subTitle: addCarAction,
                onSubTitleTap: onYourCarsTap,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: UserCars(),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
