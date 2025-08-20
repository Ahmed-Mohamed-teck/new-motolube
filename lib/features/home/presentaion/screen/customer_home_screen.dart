import 'package:flutter/material.dart';
import 'package:newmotorlube/core/providers/global_lang_provider.dart';
import '../../../../main.dart';
import '../../../customer_cars/presentation/widget/customer_cars.dart';
import '../../../promotions/presentation/widget/promotions.dart';
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
          const SizedBox(height: 32,),
          TitleWithSubTitle(
            withSubTitle: true,
            title: appLang.ourServices,
            subTitle: appLang.more,
            onSubTitleTap: () {
              Navigator.of(navigatorKey.currentContext!).pushNamed('ourServicesScreen');
            },
          ),
          HomeServiceGrid(),

          const SizedBox(height: 16,),
          TitleWithSubTitle(
            withSubTitle: true,
            title: appLang.yourCars,
            subTitle: appLang.more,
            onSubTitleTap: () {
              Navigator.of(navigatorKey.currentContext!).pushNamed('ourServicesScreen');
            },
          ),
          const SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomerCars(),
          ),
          const SizedBox(height: 16,),
          TitleWithSubTitle(
            withSubTitle: true,
            title: appLang.bestOffers,
            subTitle: appLang.more,
            onSubTitleTap: () {
              Navigator.of(navigatorKey.currentContext!).pushNamed('ourServicesScreen');
            },
          ),
          const SizedBox(height: 16,),
          Promotions(),

        ],
      ),
    );
  }
}





