import 'package:flutter/material.dart';

class CustomerCarItem extends StatelessWidget {
  final String carName;
  final String carImage;

  const CustomerCarItem({
    super.key,
    required this.carName,
    required this.carImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle car item tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on $carName')),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              carImage,
              height: 80,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            carName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
