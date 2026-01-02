import 'package:flutter/material.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/shared/utils/copy_to_clipboard.dart';
import 'package:kriptum/shared/utils/extensions/date_time_extension.dart';
import 'package:kriptum/shared/utils/format_address.dart';
import 'package:kriptum/shared/utils/url_launcher_utils.dart';
import 'package:kriptum/ui/app.dart';

class TransactionInfoDialog extends StatefulWidget {
  const TransactionInfoDialog({
    super.key,
    required this.network,
    required this.from,
    required this.toAddress,
    required this.transactionHash,
    required this.amount,
    required this.dateTime,
    required this.onPop,
    this.followOnBlockExplorerUrl,
  });
  final Network network;
  final Account from;
  final String toAddress;
  final String transactionHash;
  final BigInt amount;
  final DateTime dateTime;
  final String? followOnBlockExplorerUrl;
  final VoidCallback onPop;
  @override
  State<TransactionInfoDialog> createState() => _TransactionInfoDialogState();
}

class _TransactionInfoDialogState extends State<TransactionInfoDialog> {
  //final CopyToClipboardController copyToClipboardController = CopyToClipboardController();
  bool copiedToClipboard = false;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelMedium;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          widget.onPop();
        }
      },
      child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 1),
          content: Builder(builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return SizedBox(
              width: width - 100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.status,
                            style: labelStyle,
                          ),
                          Text(AppLocalizations.of(context)!.confirmed),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.date,
                            style: labelStyle,
                          ),
                          Text(widget.dateTime.toReadableString()),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.from,
                            style: labelStyle,
                          ),
                          Text(formatAddress(widget.from.address)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.to,
                            style: labelStyle,
                          ),
                          Text(formatAddress(widget.toAddress)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(AppLocalizations.of(context)!.transactionHash),
                    subtitle: Text(
                      widget.transactionHash,
                      overflow: TextOverflow.clip,
                    ),
                    trailing: copiedToClipboard
                        ? IconButton(onPressed: () {}, icon: const Icon(Icons.check))
                        : IconButton(
                            onPressed: () {
                              copyToClipboard(
                                content: widget.transactionHash,
                                onCopied: (content) {
                                  setState(() {
                                    copiedToClipboard = true;
                                  });
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      setState(() {
                                        copiedToClipboard = false;
                                      });
                                    },
                                  );
                                },
                              );
                              /*  copyToClipboardController.copyToClipboard(
                                content: widget.transactionHash,
                                onCopied: (content) {
                                  setState(() {
                                    copiedToClipboard = true;
                                  });
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      setState(() {
                                        copiedToClipboard = false;
                                      });
                                    },
                                  );
                                },
                              ); */
                            },
                            icon: const Icon(Icons.copy)),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(AppLocalizations.of(context)!.amount),
                    trailing: Text(
                      '${EthereumAmount.fromWei(widget.amount).toEtherString(decimals: 2)} ${widget.network.ticker}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Spacer(),
                  widget.network.blockExplorerUrl != null
                      ? TextButton(
                          onPressed: () async {
                            await _triggerViewTxOnBlockExplorer(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .viewOnBlockExplorerPlaceholder(widget.network.blockExplorerName ?? 'Block Explorer'),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ))
                      : Container(),
                ],
              ),
            );
          }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.sentAmount(widget.network.ticker),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close))
            ],
          )),
    );
  }

  _triggerViewTxOnBlockExplorer(BuildContext context) async {
    await UrlLauncherUtils.launchInBrowser(widget.followOnBlockExplorerUrl ?? '');
  }
}
