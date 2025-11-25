import 'package:flutter/material.dart';
import 'package:newmotorlube/features/upcoming_service/presentation/widget/upcoming_service_section.dart';

import '../../../../generated/l10n.dart';

class CustomerAppointmentsScreen extends StatelessWidget {
  const CustomerAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.upcomingService),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: const UpcomingServiceSection(),
        ),
      ),
    );
  }
}
