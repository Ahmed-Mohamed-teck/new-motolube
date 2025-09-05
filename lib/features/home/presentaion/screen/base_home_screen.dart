import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/core/widget/home_app_bar.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
import 'package:newmotorlube/features/home/presentaion/screen/customer_home_screen.dart';
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

    ref.listen(currentNavBottomIndexProvider, (_, currentIndex) {
      // Update the appBarTitle based on the current index
      switch (currentIndex) {
        case 0:
          _tabController.index = 0;
          break;
        case 1:
          _tabController.index = 1;
          break;
        case 2:
          _tabController.index = 2;
          break;
        case 3:
          _tabController.index = 3;
          break;
        case 4:
          _tabController.index = 4;
          break;
        default:
          appBarTitle = S.of(context).homeAppbar; // Default title
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
            screens: [
              CustomerHomeScreen(),
              // ManagerHomeScreen(),
              // AddNewCarScreen(),
              UserCarsListScreen(),
              BookServiceScreen(),
              ContactUsScreen(),
              MoreScreen(),
            ],
            onItemSelected: (int index) {
              ref.read(currentNavBottomIndexProvider.notifier).state = index;
            },
            items: [
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
            ],
            navBarStyle: NavBarStyle.style3,
          ),
        ),
      ),
    );
  }
}
