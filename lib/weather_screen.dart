import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  late Future<Map<String, dynamic>> weather;
  
  Future<Map<String,dynamic>> currentData () async {
    try {
      String cityName = "jaipur";
      final result = await http.get(Uri.parse("http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeathearAPIKey"),);
      final data = jsonDecode(result.body);
      
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data; // Ensure a Map<String, dynamic> is returned
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState(){
    super.initState();
    weather = currentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              )
          ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: const CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final windSpeed = currentWeatherData['wind']['speed'];
          final currentHumidity = currentWeatherData['main']['humidity'];

          return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY:10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp K',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12,),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain' ? Icons.cloud : Icons.sunny, size: 64,),
                            SizedBox(height: 12,),
                            Text(
                              currentSky,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                ),
              ),
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text("Hourly Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16,),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount : 5,
                  itemBuilder: (context, index) {
                    final hourlyForecast = data['list'][index + 1];
                    final hourlyTemp = hourlyForecast['main']['temp'].toString();
                    final forecastTime = DateTime.parse(hourlyForecast['dt_txt']);
                    final sky = hourlyForecast['weather'][0]['main'] == 'Clouds' || hourlyForecast['weather'][0]['main'] == 'Rain' ? Icons.cloud : Icons.sunny;
                    return HourlyForecast(
                      time: DateFormat.Hm().format(forecastTime),
                      Temperature: hourlyTemp,
                      icon: sky );
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text("Additonal Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                AdditionalInfo(icon: Icons.water_drop, label: 'Humidity', value: currentHumidity.toString(),),
                AdditionalInfo(icon: Icons.air, label: 'Wind Speed', value: windSpeed.toString(),),
                AdditionalInfo(icon: Icons.beach_access, label: 'Pressure', value: currentPressure.toString(),),
              ],)
            ],
          ),
        );
        },
      ),
    );
  }
}

