import 'package:http/http.dart';

import '../core/api_client.dart';
import '../models/request_token_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<RequestTokenModel> getRequestToken();
  Future<RequestTokenModel> validateWithLogin(Map<String, dynamic> requestBody);
  Future<String?> createSession(Map<String, dynamic> requestBody);
  Future<bool> deleteSession(String sessionId);
  Future<int?> getAccountId(String sessionId);
}

class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  final ApiClient _client;

  AuthenticationRemoteDataSourceImpl(this._client);

  @override
  Future<RequestTokenModel> getRequestToken() async {
    final response = await _client.get('/authentication/token/new');
    print("getRequestToken fired ${response}");
    final requestTokenModel = RequestTokenModel.fromJson(response);
    return requestTokenModel;
  }

  @override
  Future<RequestTokenModel> validateWithLogin(
      Map<String, dynamic> requestBody) async {
    final response = await _client.post(
      '/authentication/token/validate_with_login',
      params: requestBody,
    );

    print(
        "validateWithLogin  in authentication data source response is ${response}");
    return RequestTokenModel.fromJson(response);
  }

  @override
  Future<String?> createSession(Map<String, dynamic> requestBody) async {
    final response = await _client.post(
      '/authentication/session/new',
      params: requestBody,
    );
    print("createSession fired in authentication data source ${response}");
    return response['success'] ? response['session_id'] : null;
  }

  @override
  Future<int?> getAccountId(String sessionId) async {
    final response =
        await _client.get("/account", params: {"session_id": sessionId});
    print("getAccountId fired in authentication data source ${response}");
    return response['id'];
  }

  @override
  Future<bool> deleteSession(String sessionId) async {
    final response = await _client.deleteWithBody(
      '/authentication/session',
      params: {
        'session_id': sessionId,
      },
    );
    return response['success'] ?? false;
  }
}
