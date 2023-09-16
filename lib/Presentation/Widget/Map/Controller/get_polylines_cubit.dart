import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:task2_maps/Data/Resources/utils.dart';

part '../State/get_polylines_state.dart';

class GetPolylinesCubit extends Cubit<GetPolylinesState> {
  GetPolylinesCubit() : super(GetPolylinesInitial());

  getPolyLines(LatLng latLngPick, LatLng latLngDes) async {
    print('call');

    emit(GetPolylinesLoading());

    await AppUtils.getPolyline(latLngPick, latLngDes).then((value) {
      print(value);
      if (value.isNotEmpty) {
        emit(GetPolylinesLoaded(polyline: value));
      } else {
        emit(GetPolylinesError('No have data'));
      }
    }).catchError((e) {
      emit(GetPolylinesError('Google Map Api Issues'));
      throw e;
    });
  }
}
