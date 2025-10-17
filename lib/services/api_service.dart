import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';

class ApiService {
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    //Se necesita agregar la llave de API en un archivo .env
    //EJEMPLO:OPENWEATHER_API_KEY=tu_api_key_aqui
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null) throw Exception('API Key no encontrada');

    final url = Uri.parse(
      '$_baseUrl?q=$city&appid=$apiKey&units=metric&lang=es',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener el clima');
    }
  }
}
