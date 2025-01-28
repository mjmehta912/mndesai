import 'package:mndesai/features/point_calculation/models/card_info_dm.dart';
import 'package:mndesai/features/point_calculation/models/product_dm.dart';
import 'package:mndesai/services/api_service.dart';
import 'package:mndesai/utils/helpers/secure_storage_helper.dart';

class PointsCalculationRepo {
  static Future<CardInfoDm?> getCardInfo({
    required String cardNo,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    try {
      final response = await ApiService.getRequest(
        endpoint: '/MobileEntry/cardDtl',
        queryParams: {'cardno': cardNo},
        token: token,
      );

      if (response != null && response is Map<String, dynamic>) {
        return CardInfoDm.fromJson(response);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<ProductDm>> getProducts() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/MobileEntry/item',
        token: token,
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => ProductDm.fromJson(item),
            )
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
