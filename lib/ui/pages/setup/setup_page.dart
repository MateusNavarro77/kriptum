import 'package:flutter/material.dart';
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
              const Text(
                'Wallet setup',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Import an existing wallet or create a new one',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              Expanded(child: Container()),
              OutlinedButton(
                  onPressed: () => _navigateToImportWalletPage(context),
                  child: const Text('Import using Secret Recovery Phrase')),
              const SizedBox(
                height: 8,
              ),
              FilledButton(
                  onPressed: () => _navigateToCreateNewWalletPage(context), child: const Text('Create a new wallet')),
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
