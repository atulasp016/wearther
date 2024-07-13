import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/data/models/weather_model.dart';
import 'package:weather/data/remote/api_helpers.dart';
import 'package:weather/widgets/loading_container.dart';

class CurrentData extends StatefulWidget {
  const CurrentData({super.key});

  @override
  State<CurrentData> createState() => _CurrentDataState();
}

class _CurrentDataState extends State<CurrentData> {
  String date = DateFormat('yMMMMd').format(DateTime.now());
  bool isRequestingPermission =
      false; // Add a flag to track permission requests
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
    if (isRequestingPermission) return; // Prevent multiple permission requests

    isRequestingPermission = true; // Set flag to true

    var status = await Permission.location.request();
    if (status.isGranted) {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await apiHelper.getAddressFromLatLng(currentPosition!);
      currentWeather = await apiHelper.fetchWeatherData(
          currentPosition!.latitude, currentPosition!.longitude);
      setState(() {});
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location permissions are denied'),
      ));
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.'),
      ));
    }

    isRequestingPermission = false; // Reset flag after request is handled
  }

  @override
  Widget build(BuildContext context) {
    return currentWeather == null
        ? LoadingContainer(height: MediaQuery.of(context).size.height * 0.3)
        : Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: const EdgeInsets.all(11),
            margin: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xff3C6EEF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: Colors.white70, size: 30),
                    Text(
                      apiHelper.currentAddress,
                      style: const TextStyle(fontSize: 25, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2),
                      width: 80,
                      height: 100,
                      child: Image.network(
                        'http://openweathermap.org/img/w/${currentWeather!.weather![0].icon}.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      '${currentWeather!.main!.temp!.toStringAsFixed(0)}°C',
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 60),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentWeather!.weather![0].description!,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Updated: $date',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ],
            ),
          );
  }
}
