import 'package:mndesai/services/api_service.dart';

class OtpRepo {
  static Future<dynamic> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      final response = await ApiService.getRequest(
        endpoint: '/Auth/verifyOtp',
        queryParams: {
          'MobileNo': mobileNumber,
          'OTP': otp,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
