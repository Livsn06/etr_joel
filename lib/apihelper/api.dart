import 'dart:convert';
import 'package:foodyfind/geolocator/geocoding.dart';
import 'package:foodyfind/geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class APIHelper {
  static const instance = APIHelper();

  const APIHelper();
  //USED----8b43241729msh5ae27b3684a0cbfp1757ebjsn89f9f8b347b3 -> 1st
  //USED---- 6eaee8bfc5msh31a20294a666642p1ce0a8jsne3f4fdf9d7c6 -> 2nd
  //UNUSED---- '39c8c1fd3bmsh28c638ea72bd078p121281jsnb031b3a87d62 -> 3nd
  //UNUSED---- 10a048a393msh939e0ca9698b3c7p1263b4jsnbec48b704e7a -> 4nd
  final APIKEY = '10a048a393msh939e0ca9698b3c7p1263b4jsnbec48b704e7a';

  Future<List> fetchRestaurant() async {
    String location = await GeolocatorHelper.instance.getCurrentLocation();

    Uri url = Uri.https('map-places.p.rapidapi.com', 'nearbysearch/json',
        {'location': location, 'radius': '5000', 'type': 'restaurant'});

    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': APIKEY,
      'X-RapidAPI-Host': 'map-places.p.rapidapi.com'
    });

    if (response.statusCode != 200) {
      print(response.statusCode);
      return [];
    }

    Map data = json.decode(response.body);

    return data['results'];
  }

  Future<List> fetchRestaurantbyAddress(String locationSearch) async {
    String location =
        await GeocodingrHelper.instance.getAddressLocation(locationSearch);

    Uri url = Uri.https('map-places.p.rapidapi.com', 'nearbysearch/json',
        {'location': location, 'radius': '4000', 'type': 'restaurant'});

    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': APIKEY,
      'X-RapidAPI-Host': 'map-places.p.rapidapi.com'
    });

    if (response.statusCode != 200) {
      print(response.statusCode);
      return [];
    }

    Map data = json.decode(response.body);
    if (data.isEmpty) {
      return [];
    }
    print(data);
    return data['results'];
  }

  Future<Map> fetchDetails(String placeid) async {
    Uri url = Uri.https(
        'map-places.p.rapidapi.com', 'details/json', {'place_id': placeid});

    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': APIKEY,
      'X-RapidAPI-Host': 'map-places.p.rapidapi.com'
    });

    if (response.statusCode != 200) {
      return {};
    }
    Map data = json.decode(response.body);

    print(response.statusCode);

    print(data);

    return data['result'];
  }
}
