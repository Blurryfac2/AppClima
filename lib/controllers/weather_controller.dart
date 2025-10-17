import '../models/weather_model.dart';
import '../services/api_service.dart';

class WeatherController {
  final ApiService _apiService = ApiService();

  Future<Weather> getWeather(String city) async {
    return await _apiService.fetchWeather(city);
  }
}
