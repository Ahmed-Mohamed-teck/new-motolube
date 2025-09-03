import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newmotorlube/core/utils/extensions/extensions.dart';

import '../../features/auth/presentation/view_model/auth_state.dart';
import '../../features/auth/provider/auth_provider.dart';
import '../../features/home/presentaion/screen/base_home_screen.dart';
import '../../main.dart';
import '../providers/global_lang_provider.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {

  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final authVm = ref.read(authViewModelProvider.notifier);
    final navIndex = ref.watch(currentNavBottomIndexProvider);
    String appBarTitle = appLang.homeAppbar;
    switch (navIndex) {
      case 0:
        appBarTitle = appLang.homeAppbar;
        break;
      case 1:
        appBarTitle = appLang.myCarsNav;
        break;
      case 2:
        appBarTitle = appLang.maintenanceNav;
        break;
      case 3:
        appBarTitle = appLang.contactUsAppbar;
        break;
      case 4:
        appBarTitle =  appLang.profileAppbar;
        break;
      default:
        appBarTitle = appLang.homeAppbar;
    }

    return AppBar(
      centerTitle: true,
      title: Text(
        appBarTitle,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500,

        ),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset("assets/svg/notification-icon.svg",
          ),
          onPressed: () {
            //   todo go to notification screen
            authVm.unAuthenticate();
          },
        ),
      ],
      leading: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.black),
              onPressed: () {
                navigatorKey.currentState?.pushNamed(
                  authState is AuthenticatedState
                      ? 'profileScreen'
                      : 'loginScreen',
                );
              },
            ),
            const SizedBox(width: 8),
            // Text("hello \n Ahmed >" ,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            //   color: Theme.of(context).colorScheme.onSurface,
            // ),),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
