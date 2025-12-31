import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/create_new_wallet/create_new_wallet_bloc.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/ui/widgets/linear_check_in_progress_bar_widget.dart';

class SecureWalletStep2Screen extends StatelessWidget {
  const SecureWalletStep2Screen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearCheckInProgressBar(
          currentDot: 2,
        ),
        const Icon(
          Icons.lock,
          size: 42,
        ),
        Text(
          AppLocalizations.of(context)!.secureYourWallet,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          AppLocalizations.of(context)!.secureYourWalletsPhrase,
          style: const TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () => _showSecretRecoveryPhraseDialog(context),
          child: Text(
            AppLocalizations.of(context)!.secretRecoveryPhrase,
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Center(
          child: TextButton.icon(
            onPressed: () => _showWhyItsImportantDialog(context),
            icon: const Icon(Icons.info),
            label: Text(AppLocalizations.of(context)!.whyIsItImportant),
          ),
        ),
        Expanded(
          child: Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.textExplainingWhyImportant),
                  Expanded(child: Container()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                          onPressed: () {
                            context.read<CreateNewWalletBloc>().add(
                                  AdvanceToStep3Event(),
                                );
                          },
                          child: Text(AppLocalizations.of(context)!.start)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        //child: Text('Why is it important?'))
      ],
    );
  }

  _showSecretRecoveryPhraseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.whatIsSecretRecoveryPhrase,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.secretPhraseExplanation1, textAlign: TextAlign.center),
              Text(AppLocalizations.of(context)!.secretPhraseExplanation2, textAlign: TextAlign.center),
              Text(
                AppLocalizations.of(context)!.secretPhraseExplanation3,
                textAlign: TextAlign.center,
              )
            ],
          ),
          //icon: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
        );
      },
    );
  }

  _showWhyItsImportantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.protectYourWallet,
            textAlign: TextAlign.center,
          ),
          content: Text(
            AppLocalizations.of(context)!.protectWalletDescription,
            textAlign: TextAlign.center,
          ),
          //icon: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
        );
      },
    );
  }
}
