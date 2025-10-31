import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/infra/app_version/app_version_provider.dart';
import 'package:kriptum/infra/app_version/app_version_provider_impl.dart';
import 'package:kriptum/infra/caching/cache.dart';
import 'package:kriptum/infra/caching/memory/memory_cache.dart';
import 'package:kriptum/infra/persistence/database/sqflite/sqflite_database.dart';
import 'package:kriptum/infra/persistence/database/sql_database.dart';
import 'package:kriptum/infra/persistence/user_preferences/shared_preferences/user_preferences_impl.dart';
import 'package:kriptum/infra/persistence/user_preferences/user_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> registerDrivers() async {
  injector.registerLazySingleton<SqlDatabase>(
    () => SqfliteDatabase(),
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  injector.registerLazySingleton<UserPreferences>(
    () => UserPreferencesImpl(sharedPreferences: sharedPreferences),
  );
  injector.registerLazySingleton<http.Client>(
    () => http.Client(),
  );
  injector.registerLazySingleton<Cache>(
    () => MemoryCache(),
  );
  injector.registerLazySingleton<AppVersionProvider>(
    () => AppVersionProviderImpl(),
  );
}
