import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/weather_forcast.dart';
import 'package:http/http.dart' as http;
import 'secrets.env';


class WeatherScreen extends StatefulWidget {
   final bool isDarkMode;
   final VoidCallback onTogle;
  const  WeatherScreen({super.key, required this.onTogle, required this.isDarkMode});
   

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Al Minya,EG';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'an unexpected error accoured';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 235, 235, 235),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.onTogle,
            icon: Icon(Icons.dark_mode_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                getCurrentWeather();
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final weatherData = data['list'][0];
          final temp = weatherData['main']['temp'] as num;
          final state = weatherData['weather'][0]['description'];
          final weatherIcon = weatherData['weather'][0]['main'];
          final humidity = weatherData['main']['humidity'];
          final pressure = weatherData['main']['pressure'];
          final windSpeed = weatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  (temp - 273.15).toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Icon(
                                  weatherIcon == 'clouds' ||
                                          weatherIcon == 'Rains'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 60,
                                ),
                                SizedBox(height: 10),
                                Text(state),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Weather Forecast',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: 6,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!['list'][index + 1];
                        final temp = data['main']['temp'] as num;
                        final date = DateTime.parse(data['dt_txt']);

                        return WeatherForcast(
                          time: DateFormat.Hm().format(date),
                          temp: (temp - 273.15).toStringAsFixed(1),
                          icon:
                              weatherIcon == 'clouds' || weatherIcon == 'Rains'
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalInfo(
                        number: humidity.toString(),
                        name: 'humidity',
                        icon: Icons.water_drop,
                      ),
                      AdditionalInfo(
                        number: windSpeed.toString(),
                        name: 'Wind Speed',
                        icon: Icons.air,
                      ),
                      AdditionalInfo(
                        number: pressure.toString(),
                        name: 'Pressure',
                        icon: Icons.unfold_more_double,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
