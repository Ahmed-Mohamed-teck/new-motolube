import '../../../../generated/l10n.dart';

/// Converts API status keys into short, localized labels for customer-facing UI.
String upcomingServiceStatusLabel(S s, String status) {
  final trimmed = status.trim();
  final normalized = trimmed.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

  switch (normalized) {
    case '1':
    case 'new':
    case 'newbooking':
      return s.upcomingServicesStatusNew;
    case '2':
    case 'accepted':
      return s.upcomingServicesStatusAccepted;
    case '3':
    case 'rejected':
    case '11':
    case 'companyrejected':
      return s.upcomingServicesStatusRejected;
    case '4':
    case 'drivetocustomer':
      return s.upcomingServicesStatusEnRoute;
    case '5':
    case 'arrived':
      return s.upcomingServicesStatusArrived;
    case '6':
    case 'openjobcard':
      return s.upcomingServicesStatusOpen;
    case '7':
    case 'completed':
    case 'completedjobcard':
      return s.upcomingServicesStatusCompleted;
    case '8':
    case 'invoicedpaid':
    case 'paid':
      return s.upcomingServicesStatusPaid;
    case '9':
    case 'cancelled':
    case 'canceled':
      return s.upcomingServicesStatusCancelled;
    case '10':
    case 'needapproval':
      return s.upcomingServicesStatusNeedsApproval;
    case '12':
    case 'expired':
      return s.upcomingServicesStatusExpired;
    case 'upcoming':
      return s.upcomingServicesStatusUpcoming;
    case 'pending':
    case '':
      return s.upcomingServicesStatusPending;
  }

  if (normalized.contains('expired')) {
    return s.upcomingServicesStatusExpired;
  }
  if (normalized.contains('upcoming')) {
    return s.upcomingServicesStatusUpcoming;
  }
  if (normalized.contains('pending')) {
    return s.upcomingServicesStatusPending;
  }
  if (normalized.contains('complete')) {
    return s.upcomingServicesStatusCompleted;
  }
  if (normalized.contains('cancel')) {
    return s.upcomingServicesStatusCancelled;
  }

  return _humanizeStatus(trimmed);
}

String _humanizeStatus(String status) {
  final spaced =
      status
          .replaceAllMapped(
            RegExp(r'([a-z0-9])([A-Z])'),
            (match) => '${match.group(1)} ${match.group(2)}',
          )
          .replaceAll(RegExp(r'[_-]+'), ' ')
          .trim();
  if (spaced.isEmpty) return spaced;
  return spaced[0].toUpperCase() + spaced.substring(1);
}
