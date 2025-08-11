class AppUrls {
  AppUrls._();

  static const String _baseUrl = 'https://api.healthhouseapi.com/api/v1';
  //static const String _baseUrl = 'http://10.0.20.16:4011/api/v1';

  /// post Api
  static const String register = '$_baseUrl/users/create';
  static const String login = '$_baseUrl/auth/login';
  static const String socialAuth = '$_baseUrl/auth/login';
  static const String verifySignUpOtp = '$_baseUrl/users/signup-verification';
  static const String resendOtp = '$_baseUrl/auth/resend-otp';
  static const String forgetPassword = '$_baseUrl/auth/send-otp';
  static const String verifyForgetPasswordOtp =
      '$_baseUrl/auth/verify-otp';
  static const String resetPassword = '$_baseUrl/auth/reset-password';
  static const String changePassword = '$_baseUrl/auth/change-password';
  static const String updateProfile = '$_baseUrl/auth/profile';
  static const String updateLocation = '$_baseUrl/auth/update/user-location';



  /// get Api
  static const String getUserProfile = '$_baseUrl/auth/profile';



  static const String deleteUserProfile = '$_baseUrl/auth/profile';

}
