import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/current_account/current_account_cubit.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/shared/utils/copy_to_clipboard.dart';
import 'package:kriptum/ui/pages/scan_qr_code/scan_qr_code_page.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceivePage extends StatelessWidget {
  const ReceivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentAccountCubit>(
      create: (context) => injector.get<CurrentAccountCubit>()..requestCurrentAccount(),
      child: _ReceiveView(),
    );
  }
}

class _ReceiveView extends StatelessWidget {
  const _ReceiveView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentAccountCubit, CurrentAccountState>(
      builder: (context, state) {
        if (state.account == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacings.horizontalPadding, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.receive,
                                style: const TextStyle(fontSize: 24),
                              ),
                              Text(AppLocalizations.of(context)!.network)
                            ],
                          )),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close))
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SegmentedButton(
                              onSelectionChanged: (p0) {
                                if (p0.isEmpty) return;
                                if (p0.first == 1) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const ScanQrCodePage(),
                                    ),
                                  );
                                }
                              },
                              segments: [
                                ButtonSegment<int>(value: 1, label: Text(AppLocalizations.of(context)!.scanQrCode)),
                                ButtonSegment<int>(value: 2, label: Text(AppLocalizations.of(context)!.yourQrCode))
                              ],
                              selected: const {
                                2
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          color: Colors.white,
                          child: QrImageView(
                            data: state.account!.address,
                            version: QrVersions.auto,
                            size: 250.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        children: [
                          Text(
                            '${state.account?.alias ?? state.account!.accountIndex + 1}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            '${state.account?.address}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              copyToClipboard(
                                content: state.account!.address,
                                onCopied: (content) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(AppLocalizations.of(context)!.addressCopiedToClipboard),
                                    ),
                                  );
                                },
                              );
                            },
                            label: Text(AppLocalizations.of(context)!.copyAddress),
                            icon: const Icon(Icons.copy),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
