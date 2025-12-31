import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/app_boot/app_boot_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/ui/pages/setup/setup_page.dart';
import 'package:kriptum/ui/pages/unlock_wallet/unlock_wallet_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBootBloc>(
      create: (context) => injector.get<AppBootBloc>()
        ..add(
          AppBootStarted(),
        ),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBootBloc, AppBootState>(
      listener: (context, state) {
        switch (state.appBootStatus) {
          case AppBootStatus.unknown:
            // Do nothing, just wait for the next state
            break;
          case AppBootStatus.noWallet:
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SetupPage(),
            ));
            break;
          case AppBootStatus.lockedWallet:
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => UnlockWalletPage(),
            ));
            break;
        }
      },
      child: Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.loading),
        ),
      ),
    );
  }
}
