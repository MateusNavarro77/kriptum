import 'package:flutter/material.dart';
import 'package:kriptum/l10n/app_localizations.dart';

class EraseWalletDialog extends StatelessWidget {
  final Function() onCancel;
  final Function() onContinue;
  final bool isLoading;
  const EraseWalletDialog({
    super.key,
    required this.onCancel,
    required this.onContinue,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_rounded,
            size: 64,
          ),
          Text(
            AppLocalizations.of(context)!.areYouSureEraseWallet,
            textAlign: TextAlign.center,
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppLocalizations.of(context)!.eraseWalletWarning1, textAlign: TextAlign.center),
          const SizedBox(
            height: 24,
          ),
          Text(AppLocalizations.of(context)!.eraseWalletWarning2, textAlign: TextAlign.center),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
              onPressed: isLoading ? null : () => onContinue(),
              child: Text(AppLocalizations.of(context)!.iUnderstandContinue)),
          const SizedBox(
            height: 12,
          ),
          TextButton(onPressed: () => onCancel(), child: Text(AppLocalizations.of(context)!.cancel)),
        ],
      ),
    );
  }
}
