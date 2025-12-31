import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/theme/theme_bloc.dart';
import 'package:kriptum/l10n/app_localizations.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.general),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.darkTheme),
            trailing: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Switch(
                  value: state is ThemeDark,
                  onChanged: (_) => context.read<ThemeBloc>().add(
                        ThemeToggled(),
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
