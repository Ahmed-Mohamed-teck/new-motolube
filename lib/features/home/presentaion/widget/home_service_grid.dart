import 'package:flutter/material.dart';
import 'package:newmotorlube/generated/l10n.dart';

import 'home_service_card.dart';

class HomeServiceGrid extends StatelessWidget {
  const HomeServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return  GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      childAspectRatio: .75,
      padding: EdgeInsets.all(8.0),
      children: [
        HomeServiceCard(iconPath: 'assets/svg/service-icon-1.svg', title: S.of(context).basicServices),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-2.svg', title: S.of(context).majorServices),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-3.svg', title: S.of(context).carRepair),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-4.svg', title: S.of(context).batteires),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-5.svg', title: S.of(context).carEvaluation),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-6.svg', title: S.of(context).towiling),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-7.svg', title: S.of(context).mobileServices),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-8.svg', title: S.of(context).oiling),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-9.svg', title: S.of(context).flatTyre),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-10.svg', title: S.of(context).carWash),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-11.svg', title: S.of(context).insuranceClaims),
        HomeServiceCard(iconPath: 'assets/svg/service-icon-12.svg', title: S.of(context).carDetailing),
      ],
    );
  }
}
