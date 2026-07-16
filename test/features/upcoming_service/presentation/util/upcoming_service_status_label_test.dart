import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newmotorlube/features/upcoming_service/presentation/util/upcoming_service_status_label.dart';
import 'package:newmotorlube/generated/l10n.dart';

void main() {
  test('uses short English labels for API status keys', () async {
    final s = await S.load(const Locale('en'));

    expect(upcomingServiceStatusLabel(s, 'newBooking'), 'New');
    expect(upcomingServiceStatusLabel(s, 'driveToCustomer'), 'En Route');
    expect(upcomingServiceStatusLabel(s, 'openJobCard'), 'Open');
    expect(upcomingServiceStatusLabel(s, 'completedJobCard'), 'Completed');
    expect(upcomingServiceStatusLabel(s, 'invoicedPaid'), 'Paid');
    expect(upcomingServiceStatusLabel(s, 'needApproval'), 'Needs Approval');
    expect(upcomingServiceStatusLabel(s, 'companyRejected'), 'Rejected');
  });

  test('supports numeric status ids', () async {
    final s = await S.load(const Locale('en'));

    expect(upcomingServiceStatusLabel(s, '6'), 'Open');
    expect(upcomingServiceStatusLabel(s, '8'), 'Paid');
  });

  test('uses localized Arabic short labels', () async {
    final s = await S.load(const Locale('ar'));

    expect(upcomingServiceStatusLabel(s, 'openJobCard'), 'مفتوحة');
    expect(upcomingServiceStatusLabel(s, 'invoicedPaid'), 'مدفوعة');
  });
}
