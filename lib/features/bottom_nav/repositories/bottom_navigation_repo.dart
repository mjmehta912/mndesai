import 'package:mndesai/services/api_service.dart';
import 'package:mndesai/utils/helpers/secure_storage_helper.dart';

class BottomNavigationRepo {
  static Future<dynamic> getVersion({
    required String version,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/version',
        token: token,
        queryParams: {
          'Version': version,
        },
      );

      if (response == null) {
        return []; // No response (204 No Content)
      }

      if (response is List) {
        return response; // Return valid response
      }

      // If API returns an error message object, throw it
      if (response is Map<String, dynamic> && response.containsKey('error')) {
        throw response['error']; // Example: "Please update your app..."
      }

      return [];
    } catch (e) {
      throw e.toString(); // Throw error message instead of returning []
    }
  }
}
