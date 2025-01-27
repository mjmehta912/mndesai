import 'package:mndesai/features/virtual_card_generation/models/card_no_dm.dart';
import 'package:mndesai/services/api_service.dart';
import 'package:mndesai/utils/helpers/secure_storage_helper.dart';

class VirtualCardGenerationRepo {
  static Future<CardNoDm> getCardNo() async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/VirtualCard/cardno',
        token: token,
      );

      return CardNoDm.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> generateVirtualCard({
    required String mobileNo,
    required String name,
    required String cardNo,
    required String refCardNo,
    required String dob,
  }) async {
    final Map<String, dynamic> requestBody = {
      "name": name,
      "dob": dob,
      "mobile": mobileNo,
      "cardno": cardNo,
      "refcardno": refCardNo,
    };

    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      var response = await ApiService.postRequest(
        endpoint: '/VirtualCard/assign',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
