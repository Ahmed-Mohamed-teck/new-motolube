const String baseUrl = 'https://interface.taajeer.com:1027/api';
const String isRegisteredUserEndPoint = '$baseUrl/UserManagement/login';
const String sendOtpEndPoint = '$baseUrl/UserManagement/sendOtp';
const String registerEndPoint = '$baseUrl/UserManagement/register';
const String verifyOtpEndPoint = '$baseUrl/UserManagement/verifyOtp';
const String isUserRegisteredEndPoint = '$baseUrl/UserManagement/login';

String getUserInfoEndPoint(String phone) => '$baseUrl/UserManagement/user?mobileNumber=$phone';
