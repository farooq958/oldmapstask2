import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2_maps/Data/Resources/custom_search_field.dart';
import 'package:task2_maps/Data/Resources/imports.dart';
import 'package:task2_maps/Data/Resources/utils.dart';
import 'package:task2_maps/Presentation/Widget/Map/Controller/get_polylines_cubit.dart';
import 'package:task2_maps/Presentation/comman/loading_dialog.dart';

import 'Controller/get_current_location_cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String updateLocation = '';
  LatLng? markerData;
  BitmapDescriptor? icon;
  final Set<Polyline> _polyline = {};
  ValueNotifier<LatLng> markerNotifier = ValueNotifier(const LatLng(0.0, 0.0));
  ValueNotifier<LatLng> cameraMove = ValueNotifier(const LatLng(0.0, 0.0));

  ValueNotifier<String> locationNotifier = ValueNotifier('');

  GoogleMapController? _controller;

  getLocation(LatLng latLng) async {
    updateLocation = await AppUtils().getAddressFromLatLng(latLng);
    locationNotifier.value = updateLocation;
  }

  @override
  void initState() {
    // BitmapDescriptor.fromAssetImage(
    //         const ImageConfiguration(
    //           size: Size(10, 10),
    //         ),
    //         'assets/ic_Pin.png')
    //     .then((value) => icon = value);

    context.read<GetCurrentLocationCubit>().getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<GetCurrentLocationCubit, GetCurrentLocationState>(
          listener: (context, state) {
            if (state is GetCurrentLocationLoading) {
              LoadingDialog.showLoadingDialog(context);
            } else if (state is GetCurrentLocationLoaded) {
              print('state is loaded');
              markerData = state.latLng;
              getLocation(state.latLng);
              print(updateLocation);
              Navigator.pop(context);
            }
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is GetCurrentLocationLoaded) {
              print('state is Loaded');
              return ValueListenableBuilder(
                valueListenable: markerNotifier,
                builder: (context, value, child) {
                  return Stack(
                    children: [
                      BlocConsumer<GetPolylinesCubit, GetPolylinesState>(
                        listener: (context, state) {
                          if (state is GetPolylinesLoading) {
                            LoadingDialog.showLoadingDialog(context);
                          }
                          if (state is GetPolylinesLoaded) {
                            Navigator.pop(context);
                            _polyline.add(Polyline(
                                polylineId: const PolylineId(''),
                                points: state.polyline));
                            print(updateLocation);
                            Navigator.pop(context);
                          }
                          if (state is GetPolylinesError) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)));
                          }
                        },
                        builder: (context, state) {
                          if (state is GetPolylinesLoaded) {
                            return GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    value.latitude == 0.0
                                        ? markerData?.latitude ?? 0.0
                                        : value.latitude,
                                    value.longitude == 0.0
                                        ? markerData?.longitude ?? 0.0
                                        : value.longitude),
                                zoom: 10,
                              ),
                              polylines: _polyline,
                              markers: {
                                Marker(
                                  markerId: const MarkerId("Marker Current"),
                                  position: LatLng(
                                      value.latitude == 0.0
                                          ? markerData?.latitude ?? 0.0
                                          : value.latitude,
                                      value.longitude == 0.0
                                          ? markerData?.longitude ?? 0.0
                                          : value.longitude),
                                ),
                                Marker(
                                  markerId: const MarkerId("Marker Current"),
                                  position: LatLng(state.polyline[1].latitude,
                                      state.polyline[1].longitude),
                                ),
                              },
                              onMapCreated:
                                  (GoogleMapController controller) async {
                                _controller = controller;
                                // print(GetCurrentLocation.markers);
                              },
                              // onCameraMove: (position) {
                              //   print(position.target);
                              //   markerNotifier.value = LatLng(
                              //       position.target.latitude,
                              //       position.target.longitude);
                              //   Timer(const Duration(seconds: 4), () {
                              //     print('sldaslkdmas');
                              //     getLocation(LatLng(position.target.latitude,
                              //         position.target.longitude));
                              //   });
                              // },
                              // onCameraIdle: () {},
                              // onLongPress: (argument) {
                              //   markerNotifier.value = LatLng(
                              //       argument.latitude, argument.longitude);
                              //
                              //   getLocation(LatLng(
                              //       argument.latitude, argument.longitude));
                              // },
                            );
                          } else {
                            return GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    value.latitude == 0.0
                                        ? markerData?.latitude ?? 0.0
                                        : value.latitude,
                                    value.longitude == 0.0
                                        ? markerData?.longitude ?? 0.0
                                        : value.longitude),
                                zoom: 10,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId("Marker Current"),
                                  // infoWindow: InfoWindow(title: updateLocation),
                                  position: LatLng(
                                      value.latitude == 0.0
                                          ? markerData?.latitude ?? 0.0
                                          : value.latitude,
                                      value.longitude == 0.0
                                          ? markerData?.longitude ?? 0.0
                                          : value.longitude),
                                ),
                              },
                              onMapCreated:
                                  (GoogleMapController controller) async {
                                _controller = controller;
                                // print(GetCurrentLocation.markers);
                              },
                              onCameraMove: (position) {
                                print(position.target);
                                markerNotifier.value = LatLng(
                                    position.target.latitude,
                                    position.target.longitude);
                                Timer(const Duration(seconds: 4), () {
                                  print('sldaslkdmas');
                                  getLocation(LatLng(position.target.latitude,
                                      position.target.longitude));
                                });
                              },
                              onCameraIdle: () {},
                              onLongPress: (argument) {
                                markerNotifier.value = LatLng(
                                    argument.latitude, argument.longitude);

                                getLocation(LatLng(
                                    argument.latitude, argument.longitude));
                              },
                            );
                          }
                        },
                      ),
                      Positioned(
                        top: 30,
                        left: 0,
                        right: 0,
                        child: CustomSearchField(
                          pickUp: LatLng(
                              markerData!.latitude, markerData!.longitude),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: locationNotifier,
                        builder: (context, value, child) {
                          return Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                width: 400,
                                child: Center(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ));
                        },
                      )
                    ],
                  );
                },
              );
            } else if (state is GetCurrentLocationError) {
              return const Center(
                child: Text('Some Thing Wrong Please Try Again'),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
