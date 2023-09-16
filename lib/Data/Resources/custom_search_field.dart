import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:task2_maps/Applications/api/google_map_api.dart';
import 'package:task2_maps/Data/Resources/app_constans.dart';
import 'package:task2_maps/Presentation/Widget/Map/Controller/get_polylines_cubit.dart';

import 'imports.dart';

class CustomSearchField extends StatelessWidget {
  CustomSearchField({Key? key, required this.pickUp}) : super(key: key);

  TextEditingController controller = TextEditingController();

  LatLng pickUp;

  @override
  Widget build(BuildContext context) {
    print(pickUp);

    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        padding: const EdgeInsets.only(left: 10),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.yellow, width: 2),
        ),
        child: TypeAheadField(
            hideOnLoading: false,
            suggestionsCallback: (pattern) {
              List<String> empty = [];

              List<String> filteredHospitals = pattern.isEmpty
                  ? empty
                  : locations.where((filter) {
                      // You can customize the filtering logic here.
                      // In this example, it checks if the hospital name contains the query term (case-insensitive).
                      return filter
                          .toLowerCase()
                          .contains(pattern.toLowerCase());
                    }).toList();

              return filteredHospitals;
            },
            textFieldConfiguration: TextFieldConfiguration(
                onChanged: (val) {},
                controller: controller,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                )),
            itemBuilder: (BuildContext context, String itemData) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(itemData),
              );
            },
            onSuggestionSelected: (String suggestion) async {
              List<Location> locations = await locationFromAddress(suggestion);
              if (locations.isNotEmpty) {
                Location location = locations[0];
                LatLng destinationLatLng =
                    LatLng(location.latitude, location.longitude);
                context
                    .read<GetPolylinesCubit>()
                    .getPolyLines(pickUp, destinationLatLng);
              }
            }));
  }
}
