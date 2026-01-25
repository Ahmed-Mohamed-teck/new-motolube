import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeServiceCard extends StatelessWidget {
  final String title;
  final String? iconPath;
  final String? photoUrl;
  final bool isLoading;

  const HomeServiceCard({
    super.key,
    required this.title,
    this.iconPath,
    this.photoUrl,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(context),
          const SizedBox(height: 8),
          _buildTitle(context),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (isLoading) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    if (photoUrl != null && photoUrl!.trim().isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          photoUrl!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultIcon(context),
        ),
      );
    }

    if (iconPath != null && iconPath!.isNotEmpty) {
      return SizedBox(
        width: 40,
        height: 40,
        child: SvgPicture.asset(
          iconPath!,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
      );
    }

    return _defaultIcon(context);
  }

  Widget _buildTitle(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 10,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return Text(
      title,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }

  Widget _defaultIcon(BuildContext context) {
    return Icon(
      Icons.miscellaneous_services,
      size: 32,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
