import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/weather.dart';
import '../widgets/CurrentDateWidget.dart';

class HomeWeatherPage extends StatefulWidget {
  const HomeWeatherPage({super.key});

  @override
  State<HomeWeatherPage> createState() => _HomeWeatherPageState();
}

class _HomeWeatherPageState extends State<HomeWeatherPage> {

  String CasaUrl = 'https://api.openweathermap.org/data/2.5/weather?q=Casablanca&APPID=e7b7cd0bbfba607de70b6abbf35c4817';
  var _city, _pays, _tem, _hum, _pre, _des, _wind;
  var _iconCode, _iconUrl;
  dynamic weatherDataCasa;

  List<String> cities = ["Rabat", "Paris", "Tokyo", "Cairo", "New York", "Moscou"];
  List<Weather> weatherList=[];
  dynamic weatherData;

  void _getWeatherDataCasa(){
    http.get(Uri.parse(CasaUrl))
        .then((response){
      print(response.body);
      weatherDataCasa=jsonDecode(response.body);
      setState(() {
        _city=weatherDataCasa['name'];
        _pays=weatherDataCasa['sys']['country'];
        _tem=weatherDataCasa['main']['temp'];
        _pre=weatherDataCasa['main']['pressure'];
        _hum=weatherDataCasa['main']['humidity'];
        _des=weatherDataCasa['weather'][0]['description'];
        _wind=weatherDataCasa['wind']['speed'];
        _iconCode=weatherDataCasa['weather'][0]['icon'];
        _iconUrl='http://openweathermap.org/img/wn/$_iconCode.png';
      });
    })
        .catchError((onError){
      print(onError);
    });
  }

  void _getWeatherData(String city) {
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=${city}&APPID=e7b7cd0bbfba607de70b6abbf35c4817';

    http.get(Uri.parse(apiUrl))
        .then((response) {
      print(response.body);
      weatherData = jsonDecode(response.body);
      Weather weather = Weather(
        city: weatherData['name'],
        pays: weatherData['sys']['country'],
        tem: weatherData['main']['temp'],
        pre: weatherData['main']['pressure'],
        hum: weatherData['main']['humidity'],
        des: weatherData['weather'][0]['description'],
        wind: weatherData['wind']['speed'],
        iconCode: weatherData['weather'][0]['icon'],
        iconUrl: 'http://openweathermap.org/img/wn/${weatherData['weather'][0]['icon']}.png',
      );

      setState(() {
        weatherList.add(weather);
      });
    })
        .catchError((onError) {
      print(onError);
    });
  }

  void _getWeatherDataForAllCities() {
    for (var city in cities) {
      _getWeatherData(city);
    }
  }

  @override
  void initState() {
    super.initState();
    _getWeatherDataCasa();
    _getWeatherDataForAllCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 7, 3, 37),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                    Text(
                      "$_city, ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    Text(
                      "$_pays",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CurrentDateWidget(),
                  ],
                ),
                SizedBox(height: 30,),
                Image.network(
                    "${_iconUrl}"
                ),
                SizedBox(height: 20,),
                Text(
                  "$_tem°",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  width: 200,
                  height: 45,
                  child: Center(
                    child: Text(
                      "$_des",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Colors.white
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Wind",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        Text(
                          "${_wind} km/h",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Humidity",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        Text(
                          "$_hum %",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "pressure",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        Text(
                          "${_pre} Pa",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 2,
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Citly Forecast",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weatherList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Weather weather = weatherList[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 150,
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "${weather.tem}°",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Image.network(
                                  "${weather.iconUrl}",
                                ),
                                Text(
                                  "${weather.city}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
