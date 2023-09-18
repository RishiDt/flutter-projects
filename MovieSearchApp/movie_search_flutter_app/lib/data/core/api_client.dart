import 'dart:convert';

import 'package:http/http.dart';
import 'package:movie_search_flutter_app/data/core/api_constants.dart';

class ApiClient {
  Client _client; //http client
  ApiClient(this._client);

  dynamic get(String path, {Map<dynamic, dynamic>? params}) async {
    Uri newPath = getPath(path, params);
    Response response = await _client.get(
      newPath,
      headers: {
        'Content-type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic post(
    String path, {
    Map<dynamic, dynamic>? params,
    Map<dynamic, dynamic>? pathParams,
  }) async {
    print("post fired for ${path}");
    print("params for post are: ${params}");
    final response = await _client.post(
      getPath(path, pathParams),
      body: jsonEncode(params),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(
          "post response is ${response.statusCode} here is reponse ${response}");
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      print("unauthorized accesss");
      throw Exception("Unauthorized Access exception");
    } else {
      print(
          "something went wrong while making post request. reponse phrase:${response.reasonPhrase}");
      throw Exception(response.body);
    }
  }

  dynamic deleteWithBody(String path, {Map<dynamic, dynamic>? params}) async {
    print("params for deleteSession ${params}");
    Request request =
        Request('DELETE', getPath(path, null)); //creating delete request
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode(params);
    final response = await _client.send(request).then(
          (value) => Response.fromStream(value),
        );

    print("response of delete api call is ${response.statusCode}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized Access exception");
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Uri getPath(String path, Map<dynamic, dynamic>? params) {
    var paramsString = '';
    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    return Uri.parse(
        '${ApiConstants.API_URL}$path?api_key=${ApiConstants.API_KEY}$paramsString');
  }
}
