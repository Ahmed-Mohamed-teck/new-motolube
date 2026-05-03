import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        appBarTitle = appLang.profileAppbar;
        break;
      default:
        appBarTitle = appLang.homeAppbar;
    }

    return AppBar(
      centerTitle: true,
      leadingWidth: 160,
      title: Text(
        appBarTitle,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: InkWell(
        onTap: () {
          navigatorKey.currentState?.pushNamed(
            authState is AuthenticatedState ? 'profileScreen' : 'loginScreen',
          );
        },
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_outline,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _resolveProfileLabel(authState),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String _resolveProfileLabel(AuthState authState) {
    if (authState is! AuthenticatedState) {
      return appLang.login;
    }

    final user = authState.user;
    final name = user.name?.trim();
    if (name != null && name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      if (parts.isNotEmpty) {
        return parts.first;
      }
      return name;
    }

    final firstName = user.firstName?.trim();
    if (firstName != null && firstName.isNotEmpty) {
      return firstName;
    }

    final lastName = user.lastName?.trim();
    if (lastName != null && lastName.isNotEmpty) {
      return lastName;
    }

    return user.mobileNo;
  }
}
