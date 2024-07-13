import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather/data/models/weather_model.dart';

class WeatherDatabase {
  static Database? _database;
  static const String _tableName = 'weather';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'weather.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            city TEXT,
            weatherData TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertWeather(WeatherModel weather) async {
    final db = await database;
    return await db.insert(_tableName, {'city': weather.main!.temp, 'weatherData': weather.toJson()});
  }

  Future<WeatherModel?> getWeatherByCity(String city) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'city = ?',
      whereArgs: [city],
    );
    if (maps.isNotEmpty) {
      return WeatherModel.fromJson(jsonDecode(maps.first['weatherData']));
    }
    return null;
  }

  Future<int> deleteWeather(String city) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'city = ?',
      whereArgs: [city],
    );
  }

  Future<int> updateWeather(WeatherModel weather) async {
    final db = await database;
    return await db.update(
      _tableName,
      {'weatherData': weather.toJson()},
      where: 'city = ?',
      whereArgs: [weather.main!.temp],
    );
  }
}
