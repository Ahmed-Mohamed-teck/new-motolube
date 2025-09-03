import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeServiceCard extends StatelessWidget {
  final String iconPath;
  final String title;
  const HomeServiceCard({super.key,required this.iconPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.white,
      elevation: 1,
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
       children: [
        
         SizedBox(
          width: 40,
          height: 40,
          child: SvgPicture.asset(
            iconPath,

            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
       ],
      ),
    );
  }
}
