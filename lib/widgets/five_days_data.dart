import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/data/models/forcost_model.dart';
import 'package:weather/data/remote/api_helpers.dart';
import 'package:weather/utils/app_images.dart';
import 'package:weather/widgets/loading_container.dart';

class FiveDaysData extends StatefulWidget {
  const FiveDaysData({Key? key}) : super(key: key);

  @override
  State<FiveDaysData> createState() => _FiveDaysDataState();
}

class _FiveDaysDataState extends State<FiveDaysData> {
  ApiHelper apiHelper = ApiHelper();
  ForeCostModel? weatherForecast;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchWeatherForecast();
  }

  void fetchWeatherForecast() async {
    try {
      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      var forecast = await apiHelper.fetchWeatherForecast(
        position.latitude,
        position.longitude,
      );
      setState(() {
        weatherForecast = forecast;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching forecast $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(11.0),
          child: Text(
            'Five Days Weather Data',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
        SizedBox(
          height: 180,
          child: weatherForecast == null
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return const LoadingContainer(height: 180, width: 120);
                      },
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weatherForecast!.list!.length,
                      itemBuilder: (context, index) {
                        var forecast = weatherForecast!.list![index];
                        var dateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                            .parse(forecast.dtTxt!);

                        return Container(
                          margin: const EdgeInsets.only(left: 11),
                          width: 120,
                          decoration: BoxDecoration(
                              color: const Color(0xffE5E5E5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.network(
                                  'http://openweathermap.org/img/w/${forecast.weather![0].icon}.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                  '${forecast.main!.temp!.toStringAsFixed(0)}°C',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500)),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${DateFormat('HH').format(dateTime)}:',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: DateFormat('mm').format(dateTime),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

/*
 ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 40,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          const EdgeInsets.only(left: 11, top: 11, bottom: 11),
                      width: 120,
                      decoration: BoxDecoration(
                          color: const Color(0xffE5E5E5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.asset(
                              AppImages.IC_LOGO,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Text('${0}°C',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500)),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '00:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '00',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  })

*/
