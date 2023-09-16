import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2_maps/Presentation/Widget/Map/Controller/get_current_location_cubit.dart';

List<BlocProvider> providers = [
  BlocProvider(
    create: (context) => GetCurrentLocationCubit(),
  ),
];
