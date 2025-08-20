import 'package:flutter/material.dart';
import 'package:newmotorlube/main.dart';

class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({super.key});

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('this is manager home screen'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.of(navigatorKey.currentContext!).pushNamed('createPromotionScreen');
          },
          child: Text('Create Coupon'),
        ),
      ],
    );
  }
}
