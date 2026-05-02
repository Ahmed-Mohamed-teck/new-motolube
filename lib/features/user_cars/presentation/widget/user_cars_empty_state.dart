import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class UserCarsEmptyState extends StatelessWidget {
  const UserCarsEmptyState({super.key, required this.onAddCar});

  final VoidCallback onAddCar;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noCarsFound,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.userCarsEmptyDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAddCar,
                    child: Text(l10n.addCar),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
