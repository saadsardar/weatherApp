import 'dart:async';

import 'package:weatherapp/weather/meta_weather_api/meta_weather_api.dart'
    as client;

import 'models/weather.dart';

class WeatherFailure implements Exception {}

class WeatherRepository {
  WeatherRepository({client.MetaWeatherApiClient? weatherApiClient})
      : _weatherApiClient = weatherApiClient ?? client.MetaWeatherApiClient();

  final client.MetaWeatherApiClient _weatherApiClient;

  Future<Weather> getWeather(String city) async {
    final location = await _weatherApiClient.locationSearch(city);
    final woeid = location.woeid;
    final weather = await _weatherApiClient.getWeather(woeid);
    return Weather(
      //was in double
      temperature: weather.theTemp.toString(),
      location: location.title,
      condition: weather.weatherStateAbbr.toCondition,
    );
  }
}

//What I understood is that by doing this we can send the data above in our own way
//The data layer was recieving it in API way so here we used our way
extension on client.WeatherState {
  WeatherCondition get toCondition {
    switch (this) {
      case client.WeatherState.clear:
        return WeatherCondition.clear;
      case client.WeatherState.snow:
      case client.WeatherState.sleet:
      case client.WeatherState.hail:
        return WeatherCondition.snowy;
      case client.WeatherState.thunderstorm:
      case client.WeatherState.heavyRain:
      case client.WeatherState.lightRain:
      case client.WeatherState.showers:
        return WeatherCondition.rainy;
      case client.WeatherState.heavyCloud:
      case client.WeatherState.lightCloud:
        return WeatherCondition.cloudy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
