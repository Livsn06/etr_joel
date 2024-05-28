import 'package:geolocator/geolocator.dart';

class GeolocatorHelper {
  static const instance = GeolocatorHelper();

  const GeolocatorHelper();

  Future<bool> permissionEnabled() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    return true;
  }

  Future<String> getCurrentLocation() async {
    String location = await Geolocator.getCurrentPosition().then((location) {
      return "${location.latitude}, ${location.longitude}";
    }).catchError((error) {
      return "none";
    });
    return location;
  }
}
