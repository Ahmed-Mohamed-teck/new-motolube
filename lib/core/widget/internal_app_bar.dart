import 'package:flutter/material.dart';
import 'package:newmotorlube/core/utils/extensions/extensions.dart';

class InternalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const InternalAppBar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon:  Icon(Icons.arrow_back,color: context.theme.colorScheme.onSurface,),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}