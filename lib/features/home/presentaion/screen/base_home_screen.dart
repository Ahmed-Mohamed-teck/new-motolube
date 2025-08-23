import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/features/auth/provider/auth_provider.dart';
import 'package:newmotorlube/features/home/presentaion/screen/customer_home_screen.dart';
import 'package:newmotorlube/features/home/presentaion/screen/manager_home_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../contact_us/presentation/screen/contact_us_screen.dart';
import '../../../customer_cars/presentation/screen/customer_car_details_screen.dart';
import '../../../maintanance/presentation/screen/book_maintanance_screen.dart';


class BaseHomeScreen extends ConsumerStatefulWidget {
  const BaseHomeScreen({super.key});

  @override
  ConsumerState<BaseHomeScreen> createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends ConsumerState<BaseHomeScreen> {
  int _currentIndex = 0;
  String appBarTitle = "";


  @override
  void initState() {
    appBarTitle = appLang.homeAppbar;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final authVm = ref.read(authViewModelProvider.notifier);
    return  Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),),
        leading: IconButton(
          icon:  SvgPicture.asset("assets/svg/notification-icon.svg"),
          onPressed: () {
            //   todo go to notification screen
            authVm.unAuthenticate();
          },
        ),
      ),
      body: PersistentTabView(
        context,
        controller: PersistentTabController(initialIndex: _currentIndex),
        screens: [
          CustomerHomeScreen(),
          // ManagerHomeScreen(),
          CustomerCarDetailsScreen(),
          BookMaintananceScreen(),
          ContactUsScreen(),
          Center(child: Text("more content")),
        ],
        onItemSelected: (int index) {
          setState(() {
            _currentIndex = index;
            switch (index) {
              case 0:
                appBarTitle = S.of(context).homeAppbar;
                break;
              case 1:
                appBarTitle = S.of(context).contactUsAppbar;
                break;
              case 2:
                appBarTitle = S.of(context).profileAppbar;
                break;
              case 3:
                appBarTitle = S.of(context).moreAppbar;
                break;
            }
          });
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
    );
  }
}
