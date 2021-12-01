import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta_weather_api/meta_weather_api.dart';

class WeatherRequestFailure implements Exception {}
class WeatherNotFoundFailure implements Exception {}
class LocationIdRequestFailure implements Exception {}
class LocationNotFoundFailure implements Exception {}

class MetaWeatherApiClient {
  static const _baseUrl = 'www.metaweather.com';
  final http.Client _httpClient;
  MetaWeatherApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

   Future<Location> locationSearch(String query) async {
    final locationRequest = Uri.https(
      _baseUrl,
      '/api/location/search',
      <String, String>{'query': query},
    );
    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) {
      throw LocationIdRequestFailure();
    }

    final locationJson = jsonDecode(
      locationResponse.body,
    ) as List;

    if (locationJson.isEmpty) {
      throw LocationNotFoundFailure();
    }

    return Location.fromJson(locationJson.first as Map<String, dynamic>);
  }    

  Future<Weather> getWeather(int locationId) async {
    final weatherRequest = Uri.https(_baseUrl, '/api/location/$locationId');
    final weatherResponce = await _httpClient.get(weatherRequest);
    if (weatherResponce.statusCode != 200) {
      throw WeatherRequestFailure();
    }
    final bodyJson = jsonDecode(weatherResponce.body) as Map<String, dynamic>;
    if (bodyJson.isEmpty) {
      throw WeatherNotFoundFailure();
    }
    final weatherJson = bodyJson['consolidated_weather'] as List;
    if (weatherJson.isEmpty) {
      throw WeatherNotFoundFailure();
    }
    return Weather.fromJson(weatherJson.first as Map <String, dynamic>);
  }
}
