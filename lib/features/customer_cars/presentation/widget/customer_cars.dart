import 'package:flutter/material.dart';

import 'customer_car_item.dart';

class CustomerCars extends StatelessWidget {
  const CustomerCars({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CustomerCarItem(
            carName: 'Toyota Corolla',
            carImage: 'https://d8iqbmvu05s9c.cloudfront.net/ajprhqgqg1otf7d5sm7u3brf27gv',
          ),
          const SizedBox(width: 12,),
          CustomerCarItem(
            carName: 'sonata',
            carImage: 'https://d8iqbmvu05s9c.cloudfront.net/ajprhqgqg1otf7d5sm7u3brf27gv',
          ),
        ],
      ),
    );
  }
}
