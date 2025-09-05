import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newmotorlube/features/home/presentaion/screen/base_home_screen.dart';
import 'package:newmotorlube/features/user_cars/presentation/widget/user_car_home_item_card.dart';
import 'package:newmotorlube/main.dart';

import '../../domain/entity/car_entity.dart';


class UserCars extends ConsumerWidget {
  const UserCars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to car details
              navigatorKey.currentState!.pushNamed(
                'userCarDetailsScreen',
                arguments: CarEntity(
                  id: "dsfsdafkjsdjfgksadkljf",
                  oraIdStage: "oraIdStage",
                  oraPartyId: "oraPartyId",
                  oraVehicleId: "oraVehicleId",
                  arabicPlate: "9876XRR".characters.toList(),
                  englishPlate: "9876XRR".characters.toList(),
                  carModel: "MG% STD",
                  creationDate: "creationDate",
                  manufacturer: "MG",
                  modelYear: "2023",
                  carImages: [
                    "https://cdn.pixabay.com/photo/2012/05/29/00/43/car-49278_1280.jpg",
                    "https://cdn.pixabay.com/photo/2015/01/19/13/51/car-604019_1280.jpg",
                  ],
                  vinNumber: "vinNumber",
                ),
              );
            },
            child: SizedBox(
              width: 200,
              child: HomeCarOutlinedCard(
                imageUrl:
                    'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg',
                model: 'Nissan Sunny 2022',
                plate: 'ABC-1234',
                chassis: 'JTNBE46KX63012345',
                onBook: () async {
                  // open booking flow / navigate
                  ref.read(currentNavBottomIndexProvider.notifier).state = 2;
                  // Navigate to booking screen
                },
                heroTag: 'car-1-hero',
                key: const ValueKey('car-2'),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 200,
            child: HomeCarOutlinedCard(
              imageUrl:
                  'https://images.pexels.com/photos/210017/pexels-photo-210017.jpeg',
              model: 'Toyota Camry 2022',
              plate: 'ABC-1234',
              chassis: 'JTNBE46KX63012345',
              onBook: () async {
                // open booking flow / navigate
              },
              heroTag: 'car-2-hero',
            ),
          ),
        ],
      ),
    );
  }
}
