part of '../Controller/get_current_location_cubit.dart';

@immutable
abstract class GetCurrentLocationState {}

class GetCurrentLocationInitial extends GetCurrentLocationState {}

class GetCurrentLocationLoading extends GetCurrentLocationState {}

class GetCurrentLocationLoaded extends GetCurrentLocationState {
  LatLng latLng;

  String location;

  GetCurrentLocationLoaded({required this.latLng, required this.location});
}

class GetCurrentLocationError extends GetCurrentLocationState {}
