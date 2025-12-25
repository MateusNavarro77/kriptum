import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/theme/theme_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/value_objects/ethereum_address/ethereum_address.dart';
import 'package:kriptum/infra/persistence/database/sql_database.dart';
import 'package:kriptum/infra/persistence/user_preferences/user_preferences.dart';
import 'package:kriptum/infra/validators/validators.dart';
import 'package:kriptum/ui/app.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await initInjector();
  await injector.get<SqlDatabase>().initialize();
  final isDarkMode = await injector.get<UserPreferences>().isDarkModeEnabled();
  final currentTheme = isDarkMode ? ThemeDark() : ThemeLight();
  EthereumAddress.setExternalValidator(Web3EthereumAddressValidatorImpl());
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(injector.get(), currentTheme),
        ),
      ],
      child: const App(),
    ),
  );
}
