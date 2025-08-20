import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import 'package:newmotorlube/features/home/presentaion/screen/customer_home_screen.dart';
import 'package:newmotorlube/features/home/presentaion/screen/manager_home_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../../../../generated/l10n.dart';


class BaseHomeScreen extends StatefulWidget {
  const BaseHomeScreen({super.key});

  @override
  State<BaseHomeScreen> createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends State<BaseHomeScreen> {
  int _currentIndex = 0;
  String appBarTitle = "";


  @override
  void initState() {
    appBarTitle = appLang.homeAppbar;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),),
        leading: IconButton(
          icon:  SvgPicture.asset("assets/svg/notification-icon.svg"),
          onPressed: () {
            //   todo go to notification screen
          },
        ),
      ),
      body: PersistentTabView(
        context,
        controller: PersistentTabController(initialIndex: _currentIndex),
        screens: [
          // CustomerHomeScreen(),
          ManagerHomeScreen(),
          Center(child: Text("contact us")),
          Center(child: Text("profile content")),
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
            icon: const Icon(Icons.support_agent),
            title: S.of(context).contactUsNav,
            activeColorPrimary: AppColors.lightPrimary,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.person),
            title: S.of(context).profileNav,
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
