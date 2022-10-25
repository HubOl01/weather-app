import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';
import '../models/weatherModel.dart';
import '../widgets/LocationInfo.dart';
import '../widgets/weatherWidgets.dart';

class WeatherPage extends StatefulWidget {
  final Placemark placemark;
  WeatherPage(this.placemark, {super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // const WeatherPage({Key? key, required this.cityName}) : super (key: key);
/*   List<Weather> weatherForecast = [
    Weather(dateTime: DateTime.now(), degree: 20, iconUrl: "04d", clouds: 90),
    Weather(dateTime: DateTime.now().add(Duration(hours: 3)), degree: 23, iconUrl: "03d", clouds: 50),
    Weather(dateTime: DateTime.now().add(Duration(hours: 6)), degree: 25, iconUrl: "02d", clouds: 50),
    Weather(dateTime: DateTime.now().add(Duration(hours: 9)), degree: 28, iconUrl: "01d", clouds: 50),
  ]; */
  List<Weather> weatherForecast = [];
  List<ListItem> itemsToBuild = [];
  bool _isLoading = true;
  Placemark? _placemark;

  /* String _lat = "";
  String _lon = ""; */

  /* @override
  void initState() {
    DateTime now = DateTime.now();
    DateTime currentDay = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    weatherForecast.add(DayHeading(dateTime: currentDay));

    List weatherData = [
      Weather(dateTime: currentDay, degree: 20, iconUrl: "04d", clouds: 90),
      Weather(
          dateTime: currentDay.add(const Duration(hours: 6)),
          degree: 23,
          iconUrl: "03d",
          clouds: 50),
      Weather(
          dateTime: currentDay.add(const Duration(hours: 12)),
          degree: 25,
          iconUrl: "02d",
          clouds: 40),
      Weather(
          dateTime: currentDay.add(const Duration(hours: 18)),
          degree: 25,
          iconUrl: "01d",
          clouds: 10),
      Weather(
          dateTime: currentDay.add(const Duration(hours: 24)),
          degree: 20,
          iconUrl: "03d",
          clouds: 60),
      Weather(
          dateTime: currentDay.add(const Duration(hours: 30)),
          degree: 23,
          iconUrl: "02d",
          clouds: 70),
      Weather(
          dateTime: currentDay.add(const Duration(hours: 36)),
          degree: 23,
          iconUrl: "02d",
          clouds: 40),
      Weather(
          dateTime: currentDay.add(const Duration(hours: 42)),
          degree: 20,
          iconUrl: "02d",
          clouds: 40),
      Weather(
          dateTime: currentDay.add(const Duration(hours: 48)),
          degree: 20,
          iconUrl: "02d",
          clouds: 40),
    ];

    DateTime nextDay =
        DateTime(currentDay.year, currentDay.month, currentDay.day, 23, 59, 59);

    for (var element in weatherData) {
      element = element as Weather;
      if (element.dateTime.isAfter(nextDay)) {
        currentDay = nextDay;
        nextDay = DateTime(
            currentDay.year, currentDay.month, currentDay.day + 1, 23, 59, 59);
            weatherForecast.add(DayHeading(dateTime: currentDay.add(Duration(days: 1))));
      }
      weatherForecast.add(element);
    }

    super.initState();
  }
 */
/*   @override
  void initState() {
    _startLoadingData();
    super.initState();
  } */

/*   _startLoadingData() async {
    _getWeatherData();
  } */

  /* Future<Position>  */ /* _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {

    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  Position currentPosition = await Geolocator.getCurrentPosition();
  _lat = currentPosition.latitude.toString();
  _lon = currentPosition.longitude.toString();
} */
  @override
  void initState() {
    _placemark = widget.placemark;
    _getWeatherData();
    super.initState();
  }

/*   @override
  void didChangeDependencies() {
    _placemark = LocationInfo.of(context).placemark;
    _getWeatherData();
  } */

  _getWeatherData() async {
    if (_placemark == null) return;
    Map<String, dynamic> _queryParams = {
      "APPID": Constants.WEATHER_APP_ID,
      "units": "metric",
      "lat": _placemark!.lat.toString(),
      "lon": _placemark!.lon.toString(),
    };

    var uri = Uri.https(Constants.WEATHER_BASE_URL,
        Constants.WEATHER_FORECAST_URL, _queryParams);
    var response = await http.get(uri);

    var parsedResponse = jsonDecode(response.body);

    if (parsedResponse["cod"] != "200") return;
    parsedResponse["list"].forEach((period) {
      var dateTime = DateTime.fromMillisecondsSinceEpoch(period["dt"] * 1000);
      var degree = period["main"]["temp"];
      var clouds = period["clouds"]["all"];
      var icon = period["weather"][0]["icon"];

      weatherForecast.add(Weather(
          dateTime: dateTime, degree: degree, iconUrl: icon, clouds: clouds));
    });
    initWeatherWithdata();
/*     setState(() {
      _isLoading = false;
    }); */
  }

  initWeatherWithdata() {
    var now = DateTime.now();
    var itCurrentDay = now;
    var itNextDay = DateTime(now.year, now.month, now.day + 1, 0, 0, 0, 0, 0);

    itemsToBuild.add(DayHeading(dateTime: now));
    for (int i = 0; i < weatherForecast.length; i++) {
      if (weatherForecast[i].getDateTime() == itNextDay) {
        itCurrentDay = itNextDay;
        itNextDay = DateTime(
            itNextDay.year, itNextDay.month, itNextDay.day + 1, 0, 0, 0, 0, 0);
        itemsToBuild.add(DayHeading(dateTime: itCurrentDay));
        itemsToBuild.add(weatherForecast[i]);
      } else if (weatherForecast[i].getDateTime().isAfter(itNextDay)) {
        itCurrentDay = itNextDay;
        itNextDay = DateTime(
            itNextDay.year, itNextDay.month, itNextDay.day + 1, 0, 0, 0, 0, 0);
        itemsToBuild.add(DayHeading(dateTime: itCurrentDay));
      } else {
        itemsToBuild.add(weatherForecast[i]);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
/*     return ListView(
      children: weatherForecast.map((Weather currentWeather) => WeatherWidget(weather: currentWeather)).toList(),
    ); */
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_isLoading ? "" : _placemark!.cityName),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: weatherForecast.length,
                itemBuilder: (BuildContext ctx, int index) {
                  /* return WeatherWidget(weather: weatherForecast[index]); */
                  /*           if (weatherForecast[index] is Weather) {
              return WeatherWidget(weather: weatherForecast[index]);
            } else if (weatherForecast[index] is DayHeading) {
              return DayHeadingWidget(dayHeading: weatherForecast[index]);
            } else {
              return Text("Неверный тип");
            } */
                  final item = itemsToBuild[index];
                  if (item is Weather)
                    return WeatherWidget(
                      weather: item,
                    );
                  else if (item is DayHeading)
                    return DayHeadingWidget(dayHeading: item);
                  else
                    return Text("Error type");
                  // return WeatherWidget(weather: weatherForecast[index]);
                }),
      );
    }
  }
}
