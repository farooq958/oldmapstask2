import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:task2_maps/Data/Resources/imports.dart';

class LocationApi {
  List<Prediction> _predication = [];

  Future<List<Prediction>> searchLocation(String text) async {
    if (text.isNotEmpty) {
      http.Response response = await getLocation(text);
      var data = jsonDecode(response.body);
      var pred = data['predictions'];
      print(data);
      print(response);
      if (response.statusCode == 200) {
        print(response.reasonPhrase);

        _predication = [];
        pred.forEach(
            (prediction) => _predication.add(Prediction.fromJson(prediction)));
        print(_predication.last);
      }
    }
    return _predication;
  }

  static Future<http.Response> getLocation(String text) async {
    http.Response response;

    response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=$googleApikey',
        ),
        headers: {"Content-Type": "application/json"});

    return response;
  }
}
