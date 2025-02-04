import 'package:mndesai/features/bill_entry/models/vehicle_no_dm.dart';
import 'package:mndesai/features/point_calculation/models/card_info_dm.dart';
import 'package:mndesai/features/point_calculation/models/product_dm.dart';
import 'package:mndesai/features/virtual_card_generation/models/salesman_dm.dart';
import 'package:mndesai/services/api_service.dart';
import 'package:mndesai/utils/helpers/secure_storage_helper.dart';

class BillEntryRepo {
  static Future<List<ProductDm>> getProducts({
    required String pCode,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/MobileEntry/item',
        queryParams: {
          'PCODE': pCode,
        },
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

  static Future<CardInfoDm?> getCardInfo({
    required String cardNo,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

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

  static Future<List<VehicleNoDm>> getVehicleNos({
    required String pCode,
    String searchText = '',
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final response = await ApiService.getRequest(
        endpoint: '/MobileEntry/vehicle',
        token: token,
        queryParams: {
          'PCODE': pCode,
          'SearchText': searchText,
        },
      );
      if (response == null) {
        return [];
      }

      if (response['data'] != null) {
        return (response['data'] as List<dynamic>)
            .map(
              (item) => VehicleNoDm.fromJson(item),
            )
            .toList();
      }

      return [];
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

  static Future<dynamic> saveBillEntry({
    required String type,
    required String pCode,
    required double amount,
    required String vehicleNo,
    required String cardNo,
    required String typeCode,
    required String seCode,
    required List<Map<String, dynamic>> items,
  }) async {
    String? token = await SecureStorageHelper.read(
      'token',
    );

    try {
      final Map<String, dynamic> requestBody = {
        "TYPE": type,
        "PCODE": pCode,
        "AMOUNT": amount,
        "VEHICLENO": vehicleNo,
        "CARDNO": cardNo,
        "TYPECODE": typeCode,
        "SECODE": seCode,
        "ItemData": items,
      };

      print(requestBody);

      var response = await ApiService.postRequest(
        endpoint: '/MobileEntry/save',
        requestBody: requestBody,
        token: token,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
