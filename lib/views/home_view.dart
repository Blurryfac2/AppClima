import 'package:flutter/material.dart';
import '../controllers/weather_controller.dart';
import '../models/weather_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final WeatherController _controller = WeatherController();
  final TextEditingController _cityController = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;

  // Lista de ciudades de ejemplo para autocompletado
  final List<String> _ciudades = [
    'Ciudad de México',
    'Guadalajara',
    'Monterrey',
    'Cancún',
    'Puebla',
    'Mérida',
    'Tijuana',
    'León',
    'Querétaro',
    'Morelia',
  ];

  // Función para buscar clima
  void _buscarClima() async {
    if (_cityController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final weather = await _controller.getWeather(_cityController.text);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener el clima.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Función para traducir condición de inglés a español
  String traducirCondicion(String condicion) {
    switch (condicion.toLowerCase()) {
      case 'clouds':
        return 'Nublado';
      case 'rain':
        return 'Lluvioso';
      case 'clear':
        return 'Soleado';
      case 'snow':
        return 'Nevado';
      case 'thunderstorm':
        return 'Tormenta';
      default:
        return condicion;
    }
  }

  // Iconos según condición
  IconData _iconoClima(String condicion) {
    switch (condicion.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'clear':
        return Icons.wb_sunny;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Aplicación del Clima',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Campo de autocompletado
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return _ciudades.where(
                      (ciudad) => ciudad.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    );
                  },
                  onSelected: (String seleccion) {
                    _cityController.text = seleccion;
                    _buscarClima();
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                        _cityController.text = controller.text;
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Escribe el nombre de la ciudad',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _buscarClima,
                            ),
                          ),
                          onSubmitted: (_) => _buscarClima(),
                        );
                      },
                ),
                const SizedBox(height: 30),

                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.white),

                if (_weather != null && !_isLoading)
                  Expanded(
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _iconoClima(_weather!.condition),
                              size: 80,
                              color: Colors.yellowAccent,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _weather!.cityName,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${_weather!.temperature.toStringAsFixed(1)}°C',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              traducirCondicion(_weather!.condition),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
