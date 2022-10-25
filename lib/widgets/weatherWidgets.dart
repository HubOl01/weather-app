import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/main.dart';
import 'package:weather/models/weatherModel.dart';
import 'package:weather/widgets/LocationInfo.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  // const WeatherWidget(this.weather, {super.key});
  const WeatherWidget({Key? key, required this.weather}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child:
                Text(DateFormat("dd.MM.yyyy HH:mm").format(weather.dateTime)),
          ),
          Expanded(
            flex: 1,
            child: Text(weather.degree.toString() + "C"),
          ),
          Expanded(flex: 1, child: Text(weather.clouds.toString())),
          Expanded(flex: 1, child: Image.network(weather.getIconURL())),
        ],
      ),
    );
  }
}

class DayHeadingWidget extends StatelessWidget {
  final DayHeading dayHeading;
  static final DateFormat _dateFormat = DateFormat("EEEE");
  const DayHeadingWidget({
    Key? key, required this.dayHeading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Text("${_dateFormat.format(dayHeading.dateTime)} ${dayHeading.dateTime.month}.${dayHeading.dateTime.day}"),
          const Divider(),
        ],
      ),
    );
  }
}


