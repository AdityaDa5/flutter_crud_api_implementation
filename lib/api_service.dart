import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl =
      'https://farmbrothers.co.in/erp/Api_delivery/api_list';

  // Helper method to make GET requests and format terminal output
  Future<String> _makeRequest(Map<String, dynamic> queryParameters) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: queryParameters,
      );
      return 'Status Code: ${response.statusCode}\nResponse: ${response.data}\n';
    } on DioException catch (e) {
      return 'Status Code: ${e.response?.statusCode ?? 'Error'}\nMessage: ${e.message}\n';
    } catch (e) {
      return 'Unexpected Error: $e\n';
    }
  }

  Future<String> addContact({
    required String name,
    required String phone,
    required String address,
    required String fathersName,
  }) async {
    return _makeRequest({
      'method': 'add_contact',
      'name': name,
      'phone': phone,
      'address': address,
      'fathers_name': fathersName,
    });
  }

  Future<String> getContacts() async {
    return _makeRequest({'method': 'get_contacts'});
  }

  Future<String> updateContact({
    required String id,
    required String name,
    required String phone,
    required String address,
    required String fathersName,
  }) async {
    return _makeRequest({
      'method': 'update_contact',
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'fathers_name': fathersName,
    });
  }

  Future<String> deleteContact({required String id}) async {
    return _makeRequest({'method': 'delete_contact', 'id': id});
  }
}
