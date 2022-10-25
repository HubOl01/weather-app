import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:weather/models/weatherModel.dart';
import 'package:weather/pages/MapPage.dart';
import 'package:weather/pages/PlacePage.dart';
import 'package:weather/styles/Theme.dart';
import 'package:weather/widgets/LocationInfo.dart';
import 'package:weather/pages/PlacesPage.dart';
import 'package:weather/widgets/weatherWidgets.dart';

import 'Constants.dart';
void main() {
  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_) => WeatherTheme()),],
  child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocationInheritedWidget(
      MaterialApp(
        title: 'Flutter Demo',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        theme: Provider.of<WeatherTheme>(context).currentTheme,
        initialRoute: "/",
        onGenerateRoute: getRoutes,
        /* LocationInheritedWidget(
              WeatherPage("Moscow"),
            )), */
      ),
    );
  }

  Route getRoutes(RouteSettings settings) {
    late Widget pageToDisplay;

    switch (settings.name) {
      case "/":
        pageToDisplay = PlacesPage();
        break;
        case "/city": {
          pageToDisplay = WeatherPage((settings.arguments as Map)['placemark']);
        }
        break;
        case "/map": {
        pageToDisplay = MapPage();
        }
        break;
    }

    return MaterialPageRoute(builder: (BuildContext context) {
      return pageToDisplay;
    });
  }
}
