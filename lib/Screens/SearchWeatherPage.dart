import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchWeatherPage extends StatefulWidget {
  const SearchWeatherPage({super.key});

  @override
  State<SearchWeatherPage> createState() => _SearchWeatherPageState();
}

class _SearchWeatherPageState extends State<SearchWeatherPage> {

  var _temc, _humc, _prec, _desc, _windc;
  var _iconCodec, _iconUrlc;
  dynamic weatherDataCasa;

  TextEditingController citySearch= new TextEditingController();
  var _tem, _hum, _pre, _des, _wind, _code;
  var _iconCode, _iconUrl;
  dynamic weatherData;

  var isNotSearch=true;

  void _getWeatherDataCasa(){
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=Casablanca&APPID=e7b7cd0bbfba607de70b6abbf35c4817';

    http.get(Uri.parse(apiUrl))
        .then((response){
      print(response.body);
      weatherDataCasa=jsonDecode(response.body);
      setState(() {
        _temc=weatherDataCasa['main']['temp'];
        _prec=weatherDataCasa['main']['pressure'];
        _humc=weatherDataCasa['main']['humidity'];
        _desc=weatherDataCasa['weather'][0]['description'];
        _windc=weatherDataCasa['wind']['speed'];
        _iconCodec=weatherDataCasa['weather'][0]['icon'];
        _iconUrlc='http://openweathermap.org/img/wn/$_iconCodec.png';
      });
    })
        .catchError((onError){
      print(onError);
    });
  }

  void _getWeatherData(){
    String cityName=citySearch.text;
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=${cityName}&APPID=e7b7cd0bbfba607de70b6abbf35c4817';

    http.get(Uri.parse(apiUrl))
        .then((response){
      print(response.body);
      weatherData=jsonDecode(response.body);
      setState(() {
        _tem=weatherData['main']['temp'];
        _pre=weatherData['main']['pressure'];
        _hum=weatherData['main']['humidity'];
        _des=weatherData['weather'][0]['description'];
        _wind=weatherData['wind']['speed'];
        _iconCode=weatherData['weather'][0]['icon'];
        _iconUrl='http://openweathermap.org/img/wn/$_iconCode.png';
        _code=weatherData['cod'];

        isNotSearch=false;
      });
    })
        .catchError((onError){
      print(onError);
    });
  }

  @override
  void initState() {
    super.initState();
    _getWeatherDataCasa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 7, 3, 37),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 70, 10, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Search",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            controller: citySearch,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: "Casablanca",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              floatingLabelAlignment: FloatingLabelAlignment.center,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _getWeatherData,
                        icon: Icon(
                          Icons.search_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80,),
                Image.network(
                  !isNotSearch? "${_iconUrl}" : "${_iconUrlc}",
                ),
                SizedBox(height: 20,),
                Text(
                  !isNotSearch? "$_tem°" : "$_temc°",
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
                      !isNotSearch? "${_des}" : "${_desc}",
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
                SizedBox(height: 150,),
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
                          !isNotSearch? "${_wind} km/h" : "${_windc} km/h",
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
                          !isNotSearch? "$_hum %" : "$_humc %",
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
                          !isNotSearch ? "${_pre} Pa" : "${_prec} Pa",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
