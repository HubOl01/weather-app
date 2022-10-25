import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/DBProvider.dart';
import 'package:weather/models/weatherModel.dart';
import 'package:weather/pages/PlacePage.dart';

import '../styles/Theme.dart';

class PlacesPage extends StatefulWidget {
  const PlacesPage({super.key});

  @override
  State<PlacesPage> createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  // List<Placemark> _places = [
  //   Placemark(lat: 55.7532, lon: 37.6206, cityName: "Moscow"),
  //   Placemark(lat: 48.8753, lon: 2.2950, cityName: "Paris"),
  //   Placemark(lat: 51.5011, lon: -0.1254, cityName: "London")
  // ];

  List<Placemark> _places = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    _getAllPlacemarks();
  }

  _getAllPlacemarks() async {
    _places = await DBProvider.db.getAllPlacemarks();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Places"),
        actions: [
          IconButton(
              onPressed: () {
                final provider =
                    Provider.of<WeatherTheme>(context, listen: false);
                provider.switchTheme();
              },
              icon: Icon(Icons.sunny))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _places.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                    key: Key(_places[index].cityName),
                    onDismissed: (direction) async {
                      var id = _places[index].id;
                      var resDB = await DBProvider.db.deletePlacemark(id);
                      if (resDB is int) {
                        setState(() {
                          _places.removeAt(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Место удалено")));
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Не удалось удалить")));
                      }

                      /* setState(() {
                        _places.removeAt(index);
                      }); */
                    },
                    background: Container(color: Colors.red),
                    child: ListTile(
                      title: Text(_places[index].cityName),
                      onTap: () {
/*                 Navigator.of(context).push(
                     MaterialPageRoute(
                    builder: (context){
                      return WeatherPage(
                        _places[index],
                      ); */
                        Navigator.of(context).pushNamed("/city",
                            arguments: {"placemark": _places[index]});
                      },
                    ));
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var mapResult = await Navigator.of(context).pushNamed("/map");
          if (mapResult == null) return;
/*           setState(() {
            _places.add(mapResult as Placemark);
          }); */
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) {
                return Center(child: CircularProgressIndicator());
              });
          await Future.delayed(Duration(seconds: 1), () {});
          var resDB = await DBProvider.db
              .addPlacemark(mapResult as Map<String, dynamic>);
          if (resDB is int) {
            Navigator.of(context).pop();
            setState(() {
              _isLoading = true;
              _getAllPlacemarks();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
