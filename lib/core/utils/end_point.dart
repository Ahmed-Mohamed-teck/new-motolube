const String baseUrl = 'https://interface.taajeer.com:1027/api';
const String isRegisteredUserEndPoint = '$baseUrl/UserManagement/login';

const String sendOtpEndPoint = '$baseUrl/UserManagement/sendOtp';
const String registerEndPoint = '$baseUrl/UserManagement/customer/register';
const String verifyOtpEndPoint = '$baseUrl/UserManagement/verifyOtp';

const String isUserRegisteredEndPoint = '$baseUrl/UserManagement/login';
const String getManufacturersEndPoint =
    '$baseUrl/MotorLubeApp/getManufacturers';
const String addVehicleEndPoint = '$baseUrl/MotorLubeApp/addVehicle';
String getCarModelsEndPoint(String model) =>
    '$baseUrl/MotorLubeApp/getBrands/$model';
String getCarsForCustomerEndPoint(String customerOracleId) =>
    '$baseUrl/MotorLubeApp/customer/vehicles?customerId=$customerOracleId';
String getUserInfoEndPoint(String phone) =>
    '$baseUrl/UserManagement/user?mobileNumber=$phone';
const String setTechnicianLocationEndPoint =
    '$baseUrl/MotorLubeApp/technician/setlocation';
const String searchNearbyTechniciansEndPoint =
    '$baseUrl/MotorLubeApp/technician/search/nearby';
const String getTechnicianAvailableSlotsEndPoint =
    '$baseUrl/MotorLubeApp/technician/getAvailableSlot';
String getPackagesForVehicleEndPoint(String customerId, String vehicleId) =>
    '$baseUrl/MotorLubeApp/getPackagesForVehicle/$customerId/$vehicleId/0';
String getPackagesForVehicleByCategoryEndPoint({
  required String customerId,
  required String vehicleId,
  required String category,
}) {
  final encodedCategory = Uri.encodeComponent(category);
  return '$baseUrl/MotorLubeApp/getPackagesForVehicle/$customerId/$vehicleId/1000?category=$encodedCategory';
}
const String getCustomerAppointmentsEndPoint =
    '$baseUrl/MotorLubeApp/getCustomerAppointment';
const String getTechnicianAppointmentsEndPoint =
    '$baseUrl/MotorLubeApp/getUserAppointment';
const String getBookingStatusesEndPoint =
    '$baseUrl/MotorLubeApp/getBookingStatus';
const String updateAppointmentStatusEndPoint =
    '$baseUrl/MotorLubeApp/updateStatusAppointment';
const String createServiceRequestBaseEndPoint =
    '$baseUrl/MotorLubeApp/createSR';
String getPackagesBySrEndPoint(String srNumber) =>
    '$baseUrl/MotorLubeApp/getPackagesBySR/${Uri.encodeComponent(srNumber)}';
const String createAppointmentEndPoint =
    '$baseUrl/MotorLubeApp/createAppointment';
const String initiatePaymentEndPoint =
    'https://interface.taajeer.com:1027/api/Payments/initiate';
const String getCouponsEndPoint =
    '$baseUrl/MotorLubeApp/GetCuoponList/x';
String addCouponEndPoint({
  required String appUserId,
  required String companyName,
  required String fromDate,
  required String toDate,
  required String discountRate,
  required String couponCounts,
  required String domain,
}) {
  return '$baseUrl/MotorLubeApp/AddCouponHeader/'
      '$appUserId/$companyName/$fromDate/$toDate/$discountRate/$couponCounts/$domain';
}
String getPaymentStatusEndPoint(String transactionId) =>
    '$baseUrl/Payments/status?transactionId=${Uri.encodeComponent(transactionId)}';
const String getMainCategoriesEndPoint =
    '$baseUrl/MotorLubeApp/GetMainCategories';
