import 'package:flutter/material.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import '../../../../main.dart';
import '../../../promotions/presentation/widget/promotions.dart';
import '../../../user_cars/presentation/widget/user_cars.dart';
import '../widget/home_service_grid.dart';
import '../widget/title_with_sub_title.dart';



class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Promotions(imageUrls: [
            'https://firebasestorage.googleapis.com/v0/b/motorlube.appspot.com/o/promotions%2F58ead032-5398-4d41-9e4a-1478bdd3db13.png?alt=media&token=f5f9615c-10e2-430b-b5e1-1c4c0f48e1d2',
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1600',
            'https://images.unsplash.com/photo-1503264116251-35a269479413?q=80&w=1600',
          ],),
          const SizedBox(height: 16,),
          TitleWithSubTitle(
            withSubTitle: true,

            title: appLang.ourServices,
            subTitle: Text(appLang.more,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            onSubTitleTap: () {
              Navigator.of(navigatorKey.currentContext!).pushNamed('ourServicesScreen');
            },
          ),
          HomeServiceGrid(),

          const SizedBox(height: 16,),
          TitleWithSubTitle(
            withSubTitle: true,
            title: appLang.yourCars,
            subTitle: IconButton(onPressed: (){
              navigatorKey.currentState!.pushNamed('addNewCarScreen');
            }, icon: Icon(Icons.add_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 24,)),
            onSubTitleTap: () {
              Navigator.of(navigatorKey.currentContext!).pushNamed('ourServicesScreen');
            },
          ),
          const SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: UserCars(),
          ),

          const SizedBox(height: 16,),


        ],
      ),
    );
  }
}





