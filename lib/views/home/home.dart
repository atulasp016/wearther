import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/data/models/weather_model.dart';
import 'package:weather/data/remote/api_helpers.dart';
import 'package:weather/widgets/current_data.dart';
import 'package:weather/widgets/five_days_data.dart';
import 'package:weather/widgets/grid_container.dart';
import 'package:weather/widgets/loading_container.dart';
import 'package:weather/widgets/search_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchController = TextEditingController();
  String date = DateFormat('yMMMMd').format(DateTime.now());
  ApiHelper apiHelper = ApiHelper();
  Position? currentPosition;
  WeatherModel? currentWeather;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    print(currentWeather);
  }

  Future<void> getCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await apiHelper.getAddressFromLatLng(currentPosition!);
      currentWeather = await apiHelper.fetchWeatherData(
          currentPosition!.latitude, currentPosition!.longitude);
      setState(() {});
    } else if (status.isDenied) {
      // Handle the case where the user denied the permission
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location permissions are denied'),
      ));
    } else if (status.isPermanentlyDenied) {
      // Handle the case where the user permanently denied the permission
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(11),
                child: SearchTextField(
                    mController: searchController,
                    keyboard: TextInputType.text,
                    onTap: () async {})),
            const CurrentData(),
            const FiveDaysData(),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GridTileContainer(
                    title: 'Humidity',
                    subtitle: currentWeather == null
                        ? 'N/A'
                        : '${currentWeather!.main!.humidity} %',
                    urlImage: Icons.water_drop),
                GridTileContainer(
                  title: 'Visibility',
                  subtitle: currentWeather == null
                      ? 'N/A'
                      : '${currentWeather!.visibility} km',
                  urlImage: Icons.visibility_outlined,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GridTileContainer(
                    title: 'Wind',
                    subtitle: currentWeather == null
                        ? 'N/A'
                        : '${currentWeather!.wind!.speed!.toStringAsFixed(0)} m/s',
                    urlImage: Icons.air_rounded),
                GridTileContainer(
                    title: 'Pressure',
                    subtitle: currentWeather == null
                        ? 'N/A'
                        : '${currentWeather!.main!.pressure} hPa',
                    urlImage: Icons.speed_sharp),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GridTileContainer(
                    title: 'Min Temp',
                    subtitle: currentWeather == null
                        ? 'N/A'
                        : '${currentWeather!.main!.tempMin!.toStringAsFixed(0)} °C',
                    urlImage: Icons.thermostat),
                GridTileContainer(
                  title: 'Max Temp',
                  subtitle: currentWeather == null
                      ? 'N/A'
                      : '${currentWeather!.main!.tempMax!.toStringAsFixed(0)} °C',
                  urlImage: Icons.thermostat,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
