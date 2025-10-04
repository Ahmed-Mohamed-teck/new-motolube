const String baseUrl = 'https://interface.taajeer.com:1027/api';
const String packagesBaseUrl = 'https://interface.taajeer.com:1026/api';
const String isRegisteredUserEndPoint = '$baseUrl/UserManagement/login';
const String sendOtpEndPoint = '$baseUrl/UserManagement/sendOtp';
const String registerEndPoint = '$baseUrl/UserManagement/register';
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
String getPackagesForVehicleEndPoint(String customerId, String vehicleId) =>
    '$packagesBaseUrl/MotorLubeApp/getPackagesForVehicle/$customerId/$vehicleId/0';
