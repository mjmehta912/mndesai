import 'package:mndesai/features/virtual_card_generation/models/card_help_dm.dart';
import 'package:mndesai/features/virtual_card_generation/models/card_no_dm.dart';
import 'package:mndesai/features/virtual_card_generation/models/salesman_dm.dart';
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

  static Future<List<SalesmanDm>> getSalesmen() async {
    String? token = await SecureStorageHelper.read('token');

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/salesmen',
        token: token,
      );

      if (response == null || response is! List) {
        return [];
      }

      return response
          .map(
            (item) => SalesmanDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<CardHelpDm>> getRefCardNos({
    String searchText = '',
    int pageIndex = 1,
    int pageSize = 1000,
  }) async {
    String? token = await SecureStorageHelper.read('token');

    try {
      final response = await ApiService.getRequest(
        endpoint: '/Master/cards',
        token: token,
        queryParams: {
          'SearchText': searchText,
          'PageNumber': pageIndex.toString(),
          'PageSize': pageSize.toString(),
        },
      );

      if (response == null || response is! List) {
        return [];
      }

      return response
          .map(
            (item) => CardHelpDm.fromJson(item),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }
}
