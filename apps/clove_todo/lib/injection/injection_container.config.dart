// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:clove_todo/core/database/database_service.dart' as _i998;
import 'package:clove_todo/core/network/api_client.dart' as _i972;
import 'package:clove_todo/core/network/network_info.dart' as _i430;
import 'package:clove_todo/core/services/notification_service.dart' as _i52;
import 'package:clove_todo/injection/injection_container.dart' as _i843;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final notificationModule = _$NotificationModule();
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i998.DatabaseService>(() => _i998.DatabaseService());
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
        () => notificationModule.flutterLocalNotificationsPlugin);
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i972.ApiClient>(() => registerModule.apiClient);
    gh.lazySingleton<_i52.NotificationService>(() =>
        _i52.NotificationService(gh<_i163.FlutterLocalNotificationsPlugin>()));
    gh.lazySingleton<_i430.NetworkInfo>(
        () => _i843.NetworkInfoImpl(gh<_i895.Connectivity>()));
    return this;
  }
}

class _$NotificationModule extends _i52.NotificationModule {}

class _$RegisterModule extends _i843.RegisterModule {}
