import 'package:mndesai/services/api_service.dart';

class LoginRepo {
  static Future<dynamic> loginUser({
    required String mobileNo,
    required String password,
    required String fcmToken,
    required String deviceId,
  }) async {
    final Map<String, dynamic> requestBody = {
      'mobileNo': mobileNo,
      'password': password,
      'FCMToken': fcmToken,
      'DeviceID': deviceId,
    };

    try {
      var response = await ApiService.postRequest(
        endpoint: '/Auth/login',
        requestBody: requestBody,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
