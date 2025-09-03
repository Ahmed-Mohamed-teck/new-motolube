import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../domain/entity/car_entity.dart';
import '../widget/user_car_list_item.dart';

class UserCarsListScreen extends StatelessWidget {
  const UserCarsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: ListView.builder(
        itemCount: 2, // Example item count
        itemBuilder: (context, index) {
          return CarCard(

            car: const CarInfo(
              imageUrl: 'https://images.pexels.com/photos/210019/pexels-photo-210019.jpeg',
              model: 'Toyota Camry 2022',
              plate: 'ABC-1234',
              chassis: 'JTNBE46KX63012345',
            ),
            heroTag: 'camry-1',
            onTap: () {
              // Navigate to car details
              navigatorKey.currentState!.pushNamed('userCarDetailsScreen', arguments: CarEntity(id: "dsfsdafkjsdjfgksadkljf",
                oraIdStage: "oraIdStage",
                oraPartyId: "oraPartyId",
                oraVehicleId: "oraVehicleId",
                arabicPlate: "9876XRR".characters.toList(),
                englishPlate: "9876XRR".characters.toList(),
                carModel: "MG% STD", creationDate: "creationDate",
                manufacturer: "MG", modelYear: "2023",
                carImages: [ "https://cdn.pixabay.com/photo/2012/05/29/00/43/car-49278_1280.jpg", "https://cdn.pixabay.com/photo/2015/01/19/13/51/car-604019_1280.jpg"],
                vinNumber: "vinNumber",));
            },
            onLongPress: () {
              // e.g., copy plate to clipboard or show context menu
            },

          );
        },
      ),
    );
  }
}
