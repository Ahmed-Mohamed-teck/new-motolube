import 'package:flutter/material.dart';

import '../../../app/app_color_theme.dart';


class TitleWithSubTitle extends StatelessWidget {
  final String title;
  final Widget? subTitle;
  final bool withSubTitle;
  final TextStyle? titleStyle;
  final VoidCallback? onSubTitleTap;

  const TitleWithSubTitle({
    super.key,
    required this.title,
    this.subTitle,
    this.withSubTitle = false,
    this.titleStyle,
    this.onSubTitleTap,
  }):assert(!withSubTitle || subTitle != null,'subTitle cannot be null when withSubTitle is true');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(title,style:titleStyle ??
              Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),),
          const Spacer(),
          Visibility(
              visible: withSubTitle,
              child: InkWell(
                onTap: onSubTitleTap,
                child: subTitle),
              )
        ],
      ),
    );
  }
}
