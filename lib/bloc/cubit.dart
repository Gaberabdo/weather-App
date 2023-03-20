import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/states.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
class AppCubit extends Cubit<AppStates> {
  AppCubit(this.weatherService) : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  String? cityName;
  WeatherService weatherService;
  WeatherModel? model;
  void weatherChange ({required String cityName}) async{
    emit(AppSearchLoadingHomeDataState());
    try {
      model = await weatherService.getWeather(cityName:cityName);
      emit(AppSearchSuccessHomeDataState());
    } on Exception catch (error) {
      // TODO
      print(error.toString());
      emit(AppSearchErrorHomeDataState());
    }

  }
}
