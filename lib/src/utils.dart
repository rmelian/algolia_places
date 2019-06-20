import 'dart:async';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

const kAPlacesUrl = 'https://places-dsn.algolia.net/1/places/query';

abstract class AlgoliaPlacesWebService {
  @protected
  final Client _httpClient;

  @protected
  final String _apiKey;

  String get url => kAPlacesUrl;

  Client get httpClient => _httpClient;

  String get apiKey => _apiKey;

  AlgoliaPlacesWebService({
    String apiKey,
    Client httpClient,
  })  : _httpClient = httpClient ?? Client(),
        _apiKey = apiKey;

  @protected
  String buildQuery(Map<String, dynamic> params) {
    final query = <dynamic>[];
    params.forEach((String key, dynamic val) {
      if (val != null) {
        if (val is Iterable) {
          query.add("$key=${val.map((dynamic v) => v.toString()).join("|")}");
        } else {
          query.add('$key=${val.toString()}');
        }
      }
    });
    return query.join('&');
  }

  void dispose() => httpClient.close();

  @protected
  Future<Response> doGet(String url) => httpClient.get(url);

  @protected
  Future<Response> doPost(String body) {
    return httpClient.post(url, body: body, headers: {
//      'Content-type': 'application/json',
    });
  }
}
