import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather/models/weatherModel.dart';

const String DB_NAME = "wather_db";
const String PLACES_TABLE_NAME = "Places";
const String CREATE_PLACE_TABLE = "CREATE TABLE ${PLACES_TABLE_NAME}("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "cityName TEXT,"
    "lat REAL,"
    "lon REAL"
    ")";

const List<Map<String, dynamic>> _initPlaces = [
  {"lat": 55.7532, "lon": 37.6206, "cityName": "Москва"},
  {"lat": 48.8753, "lon": 2.2950, "cityName": "Paris"},
  {"lat": 51.5011, "lon": -0.1254, "cityName": "London"}
];

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory}/$DB_NAME";

    //await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, _) async {
        await db.execute(CREATE_PLACE_TABLE);
        Batch batch = db.batch();
        _initPlaces.forEach((Map<String, dynamic> placemark) {
          batch.insert(PLACES_TABLE_NAME, placemark);
        });
        batch.commit();
      },
    );
  }

  addPlacemark(Map<String, dynamic> placemark) async {
    final db = await database;
    var newID = db.insert(PLACES_TABLE_NAME, placemark);
    return newID;
  }

  Future<List<Placemark>> getAllPlacemarks() async {
    final db = await database;
    var res = await db.query(PLACES_TABLE_NAME);
    List<Placemark> list = res.isNotEmpty
        ? res.map((Map<String, dynamic> dbRes) {
            return Placemark(
                id: dbRes["id"],
                lat: dbRes["lat"],
                lon: dbRes["lon"],
                cityName: dbRes["cityName"]);
          }).toList()
        : [];

    return list;
  }

  deletePlacemark(int id) async {
    final db = await database;
    var deleteID =
        db.delete(PLACES_TABLE_NAME, where: "id = ?", whereArgs: [id]);
    return deleteID;
  }
}
