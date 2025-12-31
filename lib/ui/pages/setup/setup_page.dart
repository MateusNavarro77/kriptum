import 'package:flutter/material.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/ui/pages/create_new_wallet/create_new_wallet_page.dart';
import 'package:kriptum/ui/pages/import_wallet/import_wallet_page.dart';
import 'package:kriptum/ui/widgets/app_version_text_widget.dart';

import 'package:kriptum/ui/widgets/main_title_app_bar_widget.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainTitleAppBarWidget(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 24,
              ),
              Text(
                AppLocalizations.of(context)!.walletSetup,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                AppLocalizations.of(context)!.importOrCreateWallet,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              Expanded(child: Container()),
              OutlinedButton(
                  onPressed: () => _navigateToImportWalletPage(context),
                  child: Text(AppLocalizations.of(context)!.importUsingSecretPhrase)),
              const SizedBox(
                height: 8,
              ),
              FilledButton(
                  onPressed: () => _navigateToCreateNewWalletPage(context),
                  child: Text(AppLocalizations.of(context)!.createNewWallet)),
              const Align(
                alignment: Alignment.center,
                child: AppVersionTextWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCreateNewWalletPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateNewWalletPage(),
      ),
    );
  }

  void _navigateToImportWalletPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ImportWalletPage(),
      ),
    );
  }
}
