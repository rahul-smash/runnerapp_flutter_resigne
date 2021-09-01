import 'package:get_it/get_it.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_network_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/payout_repository.dart';
import 'package:marketplace_service_provider/src/components/login/bloc/user_login_bloc.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/login/repository/user_authentication_repository.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/presentation/bloc/bloc.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/repository/categorys_list_network_datasource.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/components/service_location/bloc/save_location_bloc.dart';
import 'package:marketplace_service_provider/src/components/service_location/repository/service_location_auth_repository.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/duty_status_observer.dart';
import 'package:marketplace_service_provider/src/components/side_menu/repository/menu_option_repository_impl.dart';
import 'package:marketplace_service_provider/src/components/version_api/repository/version_repository.dart';
import 'package:marketplace_service_provider/src/network/components/common_network_utils.dart';
import 'network/connectivity/network_connection_observer.dart';

var getIt = GetIt.instance;

void serviceLocator() {
  getIt.registerSingleton<NetworkConnectionObserver>(
      NetworkConnectionObserver());
  getIt.registerSingleton<DutyStatusObserver>(DutyStatusObserver());
  getIt.registerSingleton<VersionAuthRepository>(VersionAuthRepository());
  getIt.registerSingleton<CommonNetworkUtils>(CommonNetworkUtils());
  getIt.registerSingleton<LoginResponse>(LoginResponse());
  getIt.registerLazySingleton(() => UserLoginBloc());
  getIt.registerLazySingleton(() => SaveLocationBloc());
  getIt.registerSingleton<UserAuthenticationRepository>(
      UserAuthenticationRepository());
  getIt.registerSingleton<ServiceLocationAuthRepository>(
      ServiceLocationAuthRepository());
  getIt.registerSingleton<DashboardRepository>(DashboardRepository());
  getIt.registerSingleton<PayoutRepository>(PayoutRepository());
  getIt.registerLazySingleton(() => CategoryBloc());
  getIt.registerSingleton<CategoryListRemoteDataSourceImpl>(
      CategoryListRemoteDataSourceImpl());
  getIt.registerSingleton<AccountStepsDetailRepositoryImpl>(
      AccountStepsDetailRepositoryImpl());
  getIt.registerSingleton<MenuOptionRepositoryImpl>(MenuOptionRepositoryImpl());
}
