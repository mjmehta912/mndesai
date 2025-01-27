import 'package:mndesai/features/point_calculation/models/card_info_dm.dart';
import 'package:mndesai/services/api_service.dart';
import 'package:mndesai/utils/helpers/secure_storage_helper.dart';

class PointsCalculationRepo {
  static Future<CardInfoDm?> getCardInfo({
    required String cardNo,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    try {
      print('Card Number: $cardNo');

      // API call
      final response = await ApiService.getRequest(
        endpoint: '/MobileEntry/cardDtl',
        queryParams: {'cardno': cardNo},
        token: token,
      );

      print('Response: $response');

      // Check if the response is valid
      if (response != null && response is Map<String, dynamic>) {
        // Parse and return the CardInfoDm
        return CardInfoDm.fromJson(response);
      } else {
        print('Response is null or invalid');
        return null;
      }
    } catch (e) {
      print('Error in getCardInfo: $e');
      rethrow;
    }
  }
}
