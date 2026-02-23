import 'package:app/shared/data/datasources/api_client.dart';

class UserDataSource {
  final ApiClient _api;

  UserDataSource(this._api);

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _api.get('/users/me');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> data) async {
    final response = await _api.put('/users/me', data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<void> deleteAccount() async {
    await _api.delete('/users/me');
  }
}
