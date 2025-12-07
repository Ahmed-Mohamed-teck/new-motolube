import 'package:flutter/material.dart';

import '../../../../core/widget/internal_app_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, this.bookingId});

  final String? bookingId;

  @override
  Widget build(BuildContext context) {
    final hasBooking = bookingId != null && bookingId!.trim().isNotEmpty;
    return Scaffold(
      appBar: InternalAppBar(title: 'Chat'),
      body: Center(
        child: Text(
          hasBooking ? 'Chat for booking $bookingId' : 'Chat',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
