import 'package:flutter/material.dart';
import 'package:weather_app/weather/weatherscreen.dart';

void main() {
  runApp(const WeatherAppMain());
}

class WeatherAppMain extends StatelessWidget {
  const WeatherAppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      title: "Weather App",
      home: const WeatherApp(),
    );
  }
}
