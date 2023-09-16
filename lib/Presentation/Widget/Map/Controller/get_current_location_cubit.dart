import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task2_maps/Data/Resources/imports.dart';
import 'package:task2_maps/Data/Resources/utils.dart';

part '../State/get_current_location_state.dart';

class GetCurrentLocationCubit extends Cubit<GetCurrentLocationState> {
  GetCurrentLocationCubit() : super(GetCurrentLocationInitial());

  getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 20));
    emit(GetCurrentLocationLoading());
    Permission.location.request();
    var perm = await Permission.location.status;
    if (perm.isGranted) {
      await AppUtils.getCurrentLocation().then((value) async {
        print("value is Here $value ");
        print(value!.latitude);
        if (!value.latitude.isNaN) {
          String location = await AppUtils()
              .getAddressFromLatLng(LatLng(value!.latitude, value.longitude));
          if (location.isNotEmpty) {
            emit(GetCurrentLocationLoaded(
                latLng: LatLng(value.latitude, value.longitude),
                location: location));
          }
        } else {
          emit(GetCurrentLocationError());
        }
      });
      print(perm);
      print('status is $perm');
    }
  }
}
