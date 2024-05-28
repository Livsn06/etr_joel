import 'package:geocoding/geocoding.dart' as geocoding;

class GeocodingrHelper {
  static const instance = GeocodingrHelper();

  const GeocodingrHelper();

  Future<String> getAddressLocation(String address) async {
    String locations =
        await geocoding.locationFromAddress(address).then((location) {
      geocoding.Location temp = location.first;
      return "${temp.latitude},${temp.longitude}";
    }).catchError((error) {
      return "none";
    });

    print(locations);
    return locations;
  }
}
