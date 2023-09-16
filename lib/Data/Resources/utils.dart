import 'package:task2_maps/Data/Resources/imports.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppUtils {
  static getPolyline(LatLng pickUp, LatLng dest) async {
    List<LatLng> polylineCoordinates = [];

    print("pick Up $pickUp");
    print(dest.toString());

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDkxGbStd_8WAnlufPb4OgOl3_kctTUbb4', // Your Google Map Key
      PointLatLng(pickUp.latitude, pickUp.longitude),
      PointLatLng(dest.latitude, dest.longitude),
      travelMode: TravelMode.driving,
    );
    print(result);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    }
    return polylineCoordinates;
  }

  static Future<Position?> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    print('completed');
    // _currentPosition = position;
    // lat = position.latitude;
    // long = position.longitude;
    // currentLatLng1 = ["$lat", "$long"];
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    String currentAddress;

    try {
      print('inam');
      if (latLng.toString().isEmpty) {
        return currentAddress = "";
      } else {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

        Placemark place = placemarks[0];
        String? name = place.name;
        String? Streats = place.street;
        String? subLocality = place.subLocality;
        String? locality = place.locality;
        String? administrativeArea = place.administrativeArea;
        String? postalCode = place.postalCode;
        String? country = place.country;
        print('places are ${placemarks[0]}');
        if (name != null &&
            subLocality != null &&
            locality != null &&
            administrativeArea != null &&
            postalCode != null &&
            country != null) {
          currentAddress =
              "${name}, ${Streats}, ${locality}, ${administrativeArea} ${postalCode}, ${country}"; //here you can used place.country and other things also
          print('current address is $currentAddress');
          return currentAddress;
        } else {
          return currentAddress = "";
        }
      }
    } catch (e) {
      print(e);
      return "";
    }
  }
}
