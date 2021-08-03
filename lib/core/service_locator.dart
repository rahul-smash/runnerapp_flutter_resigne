import 'package:get_it/get_it.dart';
import 'package:marketplace_service_provider/src/components/login/bloc/user_login_bloc.dart';
import 'package:marketplace_service_provider/src/components/version_api/repository/version_repository.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'network/connectivity/network_connection_observer.dart';

var getIt = GetIt.instance;

void serviceLocator(){
  getIt.registerSingleton<NetworkConnectionObserver>(NetworkConnectionObserver());
  getIt.registerSingleton<VersionAuthRepository>(VersionAuthRepository());
  getIt.registerSingleton<CommonNetworkUtils>(CommonNetworkUtils());
  getIt.registerLazySingleton(() => UserLoginBloc());
}