part of '../Controller/get_polylines_cubit.dart';

@immutable
abstract class GetPolylinesState {}

class GetPolylinesInitial extends GetPolylinesState {}

class GetPolylinesLoading extends GetPolylinesState {}

class GetPolylinesLoaded extends GetPolylinesState {
  List<LatLng> polyline;

  GetPolylinesLoaded({required this.polyline});
}

class GetPolylinesError extends GetPolylinesState {
  String error;

  GetPolylinesError(this.error);
}
