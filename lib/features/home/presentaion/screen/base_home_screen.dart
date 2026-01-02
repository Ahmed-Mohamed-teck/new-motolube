import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/core/widget/home_app_bar.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
import 'package:newmotorlube/features/home/presentaion/screen/customer_home_screen.dart';
import 'package:newmotorlube/features/home/presentaion/screen/credit_manager_home_screen.dart';
import 'package:newmotorlube/features/home/presentaion/screen/manager_home_screen.dart';
import 'package:newmotorlube/main.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/widget/network_status_widget.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../book_service/presentation/screen/book_maintanance_screen.dart';
import '../../../contact_us/presentation/screen/contact_us_screen.dart';
import '../../../user_cars/presentation/screen/user_cars_list_screen.dart';
import '../../../more/presentation/screen/more_screen.dart';
import '../../../auth/domain/entity/user_type.dart';
import '../../../technician/presentation/screen/technician_home_screen.dart';

final currentNavBottomIndexProvider = StateProvider<int>((ref) {
  return 0; // Default index
});

class BaseHomeScreen extends ConsumerStatefulWidget {
  const BaseHomeScreen({super.key});

  @override
  ConsumerState<BaseHomeScreen> createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends ConsumerState<BaseHomeScreen> {
  String appBarTitle = "";
  late final PersistentTabController _tabController;

  @override
  void initState() {
    appBarTitle = appLang.homeAppbar;
    _tabController = PersistentTabController(
      initialIndex: ref.read(currentNavBottomIndexProvider),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final UserType userType =
        authState is AuthenticatedState
            ? authState.user.userType
            : UserType.customer;
    final bool isCustomer = userType == UserType.customer;

    final screens =
        isCustomer
            ? const [
              CustomerHomeScreen(),
              UserCarsListScreen(),
              BookServiceScreen(),
              ContactUsScreen(),
              MoreScreen(),
            ]
            : [_RoleSpecificHome(userType: userType), const MoreScreen()];

    final items =
        isCustomer
            ? [
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.home),
                title: S.of(context).homeNav,
                activeColorPrimary: AppColors.lightPrimary,
                inactiveColorPrimary: Colors.grey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.car_repair_sharp),
                title: S.of(context).myCarsNav,
                activeColorPrimary: AppColors.lightPrimary,
                inactiveColorPrimary: Colors.grey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.add_circle_outline),
                title: S.of(context).maintenanceNav,
                activeColorPrimary: AppColors.lightPrimary,
                inactiveColorPrimary: Colors.grey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.phone_in_talk),
                title: S.of(context).contactUsNav,
                activeColorPrimary: AppColors.lightPrimary,
                inactiveColorPrimary: Colors.grey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.more_vert),
                title: S.of(context).moreNav,
                activeColorPrimary: AppColors.lightPrimary,
                inactiveColorPrimary: Colors.grey,
              ),
            ]
            : [
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.home),
                title: S.of(context).homeNav,
                activeColorPrimary: AppColors.lightPrimary,
                inactiveColorPrimary: Colors.grey,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.more_vert),
                title: S.of(context).moreNav,
                activeColorPrimary: AppColors.lightPrimary,
                inactiveColorPrimary: Colors.grey,
              ),
            ];

    final maxIndex = screens.length - 1;
    if (_tabController.index > maxIndex) {
      _tabController.jumpToTab(0);
      ref.read(currentNavBottomIndexProvider.notifier).state = 0;
    }

    ref.listen<int>(currentNavBottomIndexProvider, (_, currentIndex) {
      final targetIndex = currentIndex.clamp(0, maxIndex).toInt();
      if (_tabController.index != targetIndex) {
        _tabController.jumpToTab(targetIndex);
      }
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard if it's open
      },
      child: Scaffold(
        appBar: HomeAppBar(),
        body: NetworkStatusWidget(
          child: PersistentTabView(
            context,
            controller: _tabController,
            screens: screens,
            onItemSelected: (int index) {
              ref.read(currentNavBottomIndexProvider.notifier).state = index;
            },
            items: items,
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      ),
    );
  }
}

class _RoleSpecificHome extends StatelessWidget {
  const _RoleSpecificHome({required this.userType});

  final UserType userType;

  @override
  Widget build(BuildContext context) {
    if (userType == UserType.technician) {
      return const TechnicianHomeScreen();
    }
    if (userType == UserType.manager) {
      return const ManagerHomeScreen();
    }
    if (userType == UserType.creditManager) {
      return const CreditManagerHomeScreen();
    }

    String message;
    switch (userType) {
      case UserType.manager:
        message = 'Manager user';
        break;
      case UserType.creditManager:
        message = 'Credit manager user';
        break;
      default:
        message = 'Customer user';
    }

    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
