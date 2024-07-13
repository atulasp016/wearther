import 'package:flutter/material.dart';
import 'package:weather/views/home/home.dart';
import 'package:weather/views/splash/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashPage()
    );
  }
}


/*
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? currentWeather;
  List<Weather>? forecast;
  String? city;
  bool _isMetric = true; // Default to Celsius

  final LocalStorageService localStorageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    city = await localStorageService.getSelectedCity();
    if (city != null) {
      try {
        currentWeather = await WeatherService().fetchCurrentWeather(city!);
        forecast = await WeatherService().fetchWeatherForecast(city!);
        await localStorageService.saveWeatherData(forecast!);
        await localStorageService.saveSelectedCity(city!);
      } catch (e) {
        // If API call fails, load data from local storage
        forecast = await localStorageService.getWeatherData();
        if (forecast!.isEmpty) {
          // Handle case where there's no data to display
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load data. Please check your connection.')),
          );
        } else {
          currentWeather = forecast![0];
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load live data. Showing cached data instead.')),
          );
        }
      }
      setState(() {});
    } else {
      // Handle case where no city is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a city to view weather information.')),
      );
    }
  }

  Future<void> _searchCity() async {
    final selectedCity = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
    if (selectedCity != null) {
      setState(() {
        city = selectedCity;
      });
      _loadWeatherData();
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  String _formatTemperature(double temperature) {
    return _isMetric ? '$temperature °C' : '${(temperature * 9 / 5 + 32).toStringAsFixed(1)} °F';
  }

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return WeatherIcons.day_sunny;
      case '01n':
        return WeatherIcons.night_clear;
      case '02d':
        return WeatherIcons.day_cloudy;
      case '02n':
        return WeatherIcons.night_cloudy;
      case '03d':
      case '03n':
        return WeatherIcons.cloud;
      case '04d':
      case '04n':
        return WeatherIcons.cloudy;
      case '09d':
      case '09n':
        return WeatherIcons.showers;
      case '10d':
        return WeatherIcons.day_rain;
      case '10n':
        return WeatherIcons.night_rain;
      case '11d':
      case '11n':
        return WeatherIcons.thunderstorm;
      case '13d':
      case '13n':
        return WeatherIcons.snow;
      case '50d':
      case '50n':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.na;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchCity,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadWeatherData,
        child: currentWeather == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  BoxedIcon(
                    _getWeatherIcon(currentWeather!.iconCode),
                    size: 100,
                    color: Colors.orange,
                  ),
                  Text(
                    currentWeather!.cityName,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _formatTemperature(currentWeather!.temperature),
                    style: const TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    currentWeather!.description,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: forecast?.length ?? 0,
                itemBuilder: (context, index) {
                  final weather = forecast![index];
                  return ListTile(
                    leading: BoxedIcon(
                      _getWeatherIcon(weather.iconCode),
                      size: 40,
                      color: Colors.orange,
                    ),
                    title: Text(
                      weather.cityName,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    subtitle: Text(
                      '${_formatTemperature(weather.temperature)} - ${weather.description}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, 'New York'); // Replace with actual city selection logic
          },
          child: const Text('Select City'),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isMetric = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMetric = prefs.getBool('isMetric') ?? true;
    });
  }

  Future<void> _saveSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMetric', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temperature Unit',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            SwitchListTile(
              title: const Text('Use Metric (°C)'),
              value: _isMetric,
              onChanged: (value) {
                setState(() {
                  _isMetric = value;
                  _saveSettings(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherService {
  static const String apiKey = '802f581bc9ab92a48f60281aead91c80'; // Replace with your OpenWeatherMap API key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchCurrentWeather(String city) async {
    final String url = '$baseUrl/weather?q=$city&appid=$apiKey&units=metric'; // Adjust units as per your preference
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load current weather data');
    }
  }

  Future<List<Weather>> fetchWeatherForecast(String city) async {
    final String url = '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric'; // Adjust units as per your preference
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body)['list'];
      List<Weather> forecast = list.map((e) => Weather.fromJson(e)).toList();
      return forecast;
    } else {
      throw Exception('Failed to load weather forecast data');
    }
  }
}

class Weather {
  final String cityName;
  final String description;
  final String iconCode;
  final double temperature;

  Weather({
    required this.cityName,
    required this.description,
    required this.iconCode,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      temperature: json['main']['temp'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'description': description,
      'iconCode': iconCode,
      'temperature': temperature,
    };
  }
}

class LocalStorageService {
  static const String selectedCityKey = 'selectedCity';
  static const String weatherDataKey = 'weatherData';

  Future<String?> getSelectedCity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedCityKey);
  }

  Future<void> saveSelectedCity(String city) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(selectedCityKey, city);
  }

  Future<List<Weather>> getWeatherData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(weatherDataKey);
    if (data != null) {
      List<dynamic> jsonList = jsonDecode(data);
      List<Weather> weatherList =
      jsonList.map((e) => Weather.fromJson(e)).toList();
      return weatherList;
    } else {
      return [];
    }
  }

  Future<void> saveWeatherData(List<Weather> weatherList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList =
    weatherList.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(weatherDataKey, jsonStringList);
  }
}
*/
