import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/domain/models/city_photo.dart';
import 'package:weather_app/domain/models/coord.dart';
import 'package:weather_app/domain/models/weather_data.dart';
import 'package:http/http.dart' as http;

class Api {
  static final apiKey = dotenv.get('API_KEY');
  static final accessKey = dotenv.get('ACCESS_KEY');
  static final dio = Dio();

  // Ссылка для получения координат
//https://api.openweathermap.org/data/2.5/weather?q=London&appid=49cc8c821cd2aff9af04c9f98c36eb74

  static Future<Coord> getCoords({String cityName = 'Tashkent'}) async {
    final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&lang=ru');

    try {
      final coords = Coord.fromJson(response.data);
      return coords;
    } catch (e) {
      final coords = Coord.fromJson(response.data);
      return coords;
    }
  }

  // Ссылка для получения погоды
//https://api.openweathermap.org/data/2.5/onecall?lat=55.7522&lon=37.6156&exclude=hourly,minutely&appid=49cc8c821cd2aff9af04c9f98c36eb74

  static Future<WeatherData?> getWeather(Coord? coord) async {
    if (coord != null) {
      final lat = coord.lat.toString();
      final lon = coord.lon.toString();
      final response = await dio.get(
          'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely&appid=$apiKey&lang=ru');
      final weatherData = WeatherData.fromJson(response.data);
      return weatherData;
    }
    return null;
  }

//ссылка для получения заднего фона
//https://api.unsplash.com/search/photos?query=Tashkent
  static Future<CityPhotos> getPhoto({String cityName = 'Tashkent'}) async {
    final url =
        Uri.parse('https://api.unsplash.com/search/photos?query=$cityName');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Client-ID $accessKey',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return CityPhotos.fromJson(data);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
