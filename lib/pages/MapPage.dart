import 'package:flutter/material.dart';
import 'package:weather/models/weatherModel.dart';
import 'package:weather/widgets/LocationInfo.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late PlacemarkMapObject _placemark;
  late YandexMapController _controller;
  TextEditingController _editingController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _placemark = PlacemarkMapObject(
        mapId: MapObjectId("example"),
        point: Point(
            latitude: LocationInfo.of(context).placemark.lat,
            longitude: LocationInfo.of(context).placemark.lon));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search new place"),
      ),
      body: YandexMap(
        mapObjects: [_placemark],
        onMapCreated: _onMapCreated,
        onMapTap: _onMapTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Укажите название местоположения'),
                content: TextField(
                  controller: _editingController,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(
                        {
                          "lat": _placemark.point.latitude,
                          "lon": _placemark.point.longitude,
                          "cityName": _editingController.value.text,
                        }
                      );
                    },
                    child: Text("Сохранить"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _onMapTap(Point point) {
    setState(() {
      _placemark =
          PlacemarkMapObject(mapId: MapObjectId("newpos"), point: point);
      _controller.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: point)));
    });
  }

  void _onMapCreated(YandexMapController controller) {
    _controller = controller;
    _controller.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: Point(
            latitude: _placemark.point.latitude,
            longitude: _placemark.point.longitude),
      ),
    ));
  }
}
