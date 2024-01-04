import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import './forcastsection.dart';
import './additonal_info.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  double celcius = 273.15;

  Future<Map<String, dynamic>> getinitailWeather() async {
    try {
      // String cityName = 'London';
      // String secretAPIKey = 'ca85684815b6db91ea3dafa082c15724';
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=ca85684815b6db91ea3dafa082c15724'));

      final data = jsonDecode(res.body);

      if (int.parse(data['cod']) != 200) {
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getinitailWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final pressure = data['list'][0]['main']['pressure'];
          final humidity = data['list'][0]['main']['humidity'];
          final windSpeed = data['list'][0]['wind']['speed'];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 16,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp °K",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.sunny
                                    : Icons.cloud,
                                size: 70,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "$currentSky",
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //mini space
                const SizedBox(
                  height: 20,
                ),
                //forecast section
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 1; i < 20; i++)
                //         ForcastSection(
                //             time: data['list'][i + 1]['dt'].toString(),
                //             icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                         "Clouds" ||
                //                     data['list'][i + 1]['weather'][0]['main'] ==
                //                         "Rain"
                //                 ? Icons.cloud
                //                 : Icons.sunny,
                //             temp:
                //                 data['list'][i + 1]['main']['temp'].toString()),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 39,
                      itemBuilder: (context, index) {
                        return ForcastSection(
                            time: data['list'][index + 1]['dt'].toString(),
                            icon: data['list'][index + 1]['weather'][0]
                                            ['main'] ==
                                        "Clouds" ||
                                    data['list'][index + 1]['weather'][0]
                                            ['main'] ==
                                        "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            temp: data['list'][index + 1]['main']['temp']
                                .toString());
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Addition Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: (Icons.water_drop),
                      label: 'Humidity',
                      value: humidity.toString(),
                    ),
                    AdditionalInfo(
                      icon: (Icons.air),
                      label: "Wind speed",
                      value: windSpeed.toString(),
                    ),
                    AdditionalInfo(
                      icon: (Icons.tire_repair_rounded),
                      label: "pressure",
                      value: pressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
