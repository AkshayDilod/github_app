import 'package:get_it/get_it.dart';
import 'package:github/model/git_data_model.dart';
import 'package:github/services/api_service.dart';
import 'package:github/viewModel/main_view_model.dart';

GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<ApiService>(()=>ApiService());
  getIt.registerFactory<MainViewModel>(() => MainViewModel());
}
