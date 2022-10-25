class Weather extends ListItem{
  DateTime dateTime;
  num degree;
  String iconUrl;
  int clouds;

  Weather({
    required this.dateTime,
    required this.degree,
    required this.iconUrl,
    required this.clouds,
  });

  static const String weatherURL = "http://openweathermap.org/img/wn/";

  String getIconURL(){
    return "$weatherURL$iconUrl.png";
  }

  DateTime getDateTime(){
     return dateTime;
  }
}
  class DayHeading extends ListItem{
    final DateTime dateTime;

    DayHeading({
      required this.dateTime,
    });
  }

abstract class ListItem {}

  class Placemark{
    final double lat;
    final double lon;
    final String cityName;
    final int timeStamp = DateTime.now().millisecondsSinceEpoch;
    final int id;
    
    Placemark({
      required this.lat,
      required this.lon,
      required this.cityName,
      required this.id,
    });

    Map<String, dynamic> getPlacemark(){
      return {
        "lat": this.lat,
        "lon": this.lon,
        "cityName": this.cityName,
        "timestamp": this.timeStamp,
        "id": this.id
      };
    }
  }
