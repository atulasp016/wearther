import 'dart:async';
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/data/models/forcost_model.dart';
import 'package:weather/data/models/weather_model.dart';
import 'package:weather/data/remote/app_urls.dart';


class ApiHelper {
  late Position currentPosition;
  String currentAddress = 'Fetching location...';

  Future<WeatherModel> fetchWeatherData(
      double latitude, double longitude) async {
    final url =
        '${AppUrls.ENDPOINT_WEATHER_URL}?lat=$latitude&lon=$longitude&units=metric&appid=${AppUrls.API_KEY}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Weather Data:-----------$data');
      return WeatherModel.fromJson(data);

    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<ForeCostModel> fetchWeatherForecast(
      double latitude, double longitude) async {
    final url =
        '${AppUrls.ENDPOINT_FORRECST_URL}?lat=$latitude&lon=$longitude&units=metric&appid=${AppUrls.API_KEY}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('ForeCast Data:-------------$data');
        return ForeCostModel.fromJson(data);
      } else {
        print('Failed to load weather forecast: ${response.body}');
        throw Exception('Failed to load weather forecast');
      }
    } catch (e) {
      print('Error fetching weather forecast: $e');
      throw Exception('Failed to load weather forecast');
    }
  }

  Future getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      currentAddress = "${place.locality}, ${place.administrativeArea},";
    } catch (e) {
      print(e);
    }
  }

  Future<WeatherModel> fetchWeatherByCity(String city) async {
    final String url = '${AppUrls.BASEURL}?q=$city&appid=${AppUrls.API_KEY}&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return WeatherModel.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}






