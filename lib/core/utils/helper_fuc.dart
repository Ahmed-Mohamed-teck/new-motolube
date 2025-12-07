getStatusIdFromStatusName(String statusName) {
  switch (statusName) {
    case 'newBooking':
      return 1;
    case 'accepted':
      return 2;
    case 'rejected':
      return 3;
    case 'driveToCustomer':
      return 4;
    case 'arrived':
      return 5;
    case 'openJobCard':
      return 6;
    case 'completedJobCard':
      return 7;
    case 'invoicedPaid':
      return 8;
    case 'cancelled':
      return 9;
    case 'needApproval':
      return 10;
    case 'companyRejected':
      return 11;
    case 'expired':
      return 12;
    default:
      return 0; // Unknown status
  }
}