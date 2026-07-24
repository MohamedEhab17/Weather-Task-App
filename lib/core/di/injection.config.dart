// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../localization/cubit/language_cubit.dart' as _i866;
import '../network/api_client.dart' as _i557;
import '../network/network_info.dart' as _i932;
import 'app_module.dart' as _i460module;

// Core Weather
import '../../core/weather/data/datasources/weather_remote_data_source.dart' as _iCoreRemote;
import '../../core/weather/domain/repositories/weather_repository.dart' as _iCoreRepo;
import '../../core/weather/data/repositories/weather_repository_impl.dart' as _iCoreRepoImpl;
import '../../core/weather/domain/usecases/get_weather_usecase.dart' as _iCoreUseCase;

// Weather Dashboard Feature
import '../../features/weather_dashboard/domain/usecases/get_dashboard_weather_usecase.dart' as _iDashUseCase;
import '../../features/weather_dashboard/presentation/cubit/dashboard_cubit.dart' as _iDashCubit;

// Weather Search Feature
import '../../features/weather_search/data/datasources/search_local_data_source.dart' as _iSearchLocal;
import '../../features/weather_search/domain/repositories/search_repository.dart' as _iSearchRepo;
import '../../features/weather_search/data/repositories/search_repository_impl.dart' as _iSearchRepoImpl;
import '../../features/weather_search/domain/usecases/get_favorites_usecase.dart' as _iGetFav;
import '../../features/weather_search/domain/usecases/toggle_favorite_usecase.dart' as _iToggleFav;
import '../../features/weather_search/domain/usecases/search_city_usecase.dart' as _iSearchCity;
import '../../features/weather_search/presentation/cubit/search_cubit.dart' as _iSearchCubit;

// Weather Settings Feature
import '../../features/weather_settings/data/datasources/settings_local_data_source.dart' as _iSettingsLocal;
import '../../features/weather_settings/domain/repositories/settings_repository.dart' as _iSettingsRepo;
import '../../features/weather_settings/data/repositories/settings_repository_impl.dart' as _iSettingsRepoImpl;
import '../../features/weather_settings/domain/usecases/get_units_usecase.dart' as _iGetUnits;
import '../../features/weather_settings/domain/usecases/save_units_usecase.dart' as _iSaveUnits;
import '../../core/settings/cubit/settings_cubit.dart' as _iSettingsCubit;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();

    // ── Infrastructure ────────────────────────────────────────────────────
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i895.Connectivity>(() => appModule.connectivity);
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.lazySingleton<_i866.LanguageCubit>(() => _i866.LanguageCubit());
    gh.lazySingleton<_i557.ApiClient>(
      () => appModule.apiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );

    // ── Core Weather ──────────────────────────────────────────────────────
    gh.lazySingleton<_iCoreRemote.WeatherRemoteDataSource>(
      () => _iCoreRemote.WeatherRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_iCoreRepo.WeatherRepository>(
      () => _iCoreRepoImpl.WeatherRepositoryImpl(
        remoteDataSource: gh<_iCoreRemote.WeatherRemoteDataSource>(),
        networkInfo: gh<_i932.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_iCoreUseCase.GetWeatherUseCase>(
      () => _iCoreUseCase.GetWeatherUseCase(gh<_iCoreRepo.WeatherRepository>()),
    );

    // ── Weather Dashboard Feature ─────────────────────────────────────────
    gh.lazySingleton<_iDashUseCase.GetDashboardWeatherUseCase>(
      () => _iDashUseCase.GetDashboardWeatherUseCase(gh<_iCoreRepo.WeatherRepository>()),
    );
    gh.lazySingleton<_iDashCubit.DashboardCubit>(
      () => _iDashCubit.DashboardCubit(
        getDashboardWeatherUseCase: gh<_iDashUseCase.GetDashboardWeatherUseCase>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );

    // ── Weather Search Feature ────────────────────────────────────────────
    gh.lazySingleton<_iSearchLocal.SearchLocalDataSource>(
      () => _iSearchLocal.SearchLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_iSearchRepo.SearchRepository>(
      () => _iSearchRepoImpl.SearchRepositoryImpl(
        localDataSource: gh<_iSearchLocal.SearchLocalDataSource>(),
        remoteDataSource: gh<_iCoreRemote.WeatherRemoteDataSource>(),
        networkInfo: gh<_i932.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_iGetFav.GetFavoritesUseCase>(
      () => _iGetFav.GetFavoritesUseCase(gh<_iSearchRepo.SearchRepository>()),
    );
    gh.lazySingleton<_iToggleFav.ToggleFavoriteUseCase>(
      () => _iToggleFav.ToggleFavoriteUseCase(gh<_iSearchRepo.SearchRepository>()),
    );
    gh.lazySingleton<_iSearchCity.SearchCityUseCase>(
      () => _iSearchCity.SearchCityUseCase(gh<_iSearchRepo.SearchRepository>()),
    );
    gh.lazySingleton<_iSearchCubit.SearchCubit>(
      () => _iSearchCubit.SearchCubit(
        getFavoritesUseCase: gh<_iGetFav.GetFavoritesUseCase>(),
        toggleFavoriteUseCase: gh<_iToggleFav.ToggleFavoriteUseCase>(),
        searchCityUseCase: gh<_iSearchCity.SearchCityUseCase>(),
      ),
    );

    // ── Weather Settings Feature ──────────────────────────────────────────
    gh.lazySingleton<_iSettingsLocal.SettingsLocalDataSource>(
      () => _iSettingsLocal.SettingsLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_iSettingsRepo.SettingsRepository>(
      () => _iSettingsRepoImpl.SettingsRepositoryImpl(gh<_iSettingsLocal.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_iGetUnits.GetUnitsUseCase>(
      () => _iGetUnits.GetUnitsUseCase(gh<_iSettingsRepo.SettingsRepository>()),
    );
    gh.lazySingleton<_iSaveUnits.SaveUnitsUseCase>(
      () => _iSaveUnits.SaveUnitsUseCase(gh<_iSettingsRepo.SettingsRepository>()),
    );
    gh.lazySingleton<_iSettingsCubit.SettingsCubit>(
      () => _iSettingsCubit.SettingsCubit(
        getUnitsUseCase: gh<_iGetUnits.GetUnitsUseCase>(),
        saveUnitsUseCase: gh<_iSaveUnits.SaveUnitsUseCase>(),
      ),
    );

    return this;
  }
}

class _$AppModule extends _i460module.AppModule {}
