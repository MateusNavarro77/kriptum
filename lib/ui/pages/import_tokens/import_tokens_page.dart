import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/import_token/import_token_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/value_objects/ethereum_address/ethereum_address.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/shared/utils/show_snack_bar.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:kriptum/ui/widgets/ethereum_address_text_field.dart';

class ImportTokensPage extends StatelessWidget {
  const ImportTokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImportTokenBloc>(
      create: (context) => injector.get<ImportTokenBloc>(),
      child: const _ImportTokensPage(),
    );
  }
}

class _ImportTokensPage extends StatefulWidget {
  const _ImportTokensPage();

  @override
  State<_ImportTokensPage> createState() => _ImportTokensPageState();
}

class _ImportTokensPageState extends State<_ImportTokensPage> {
  final _tokenAddressTextFieldController = TextEditingController();
  final _tokenNameTextFieldController = TextEditingController();
  final _tokenSymbolTextFieldController = TextEditingController();
  final _tokenDecimalsTextFieldController = TextEditingController();
  final ValueNotifier<bool> _isValidTokenAddressNotifier = ValueNotifier(false);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _tokenAddressTextFieldController.addListener(
        () {
          final result = EthereumAddress.create(_tokenAddressTextFieldController.text);
          if (result.isSuccess) {
            _isValidTokenAddressNotifier.value = true;
            context.read<ImportTokenBloc>().add(
                  ValidEthereumAddressInputed(
                    _tokenAddressTextFieldController.text,
                  ),
                );
            return;
          }
          _isValidTokenAddressNotifier.value = false;
        },
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _isValidTokenAddressNotifier.dispose();
    _tokenAddressTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImportTokenBloc, ImportTokenState>(
      listenWhen: (previous, current) {
        return previous.fetchTokenInfoStatus != current.fetchTokenInfoStatus ||
            previous.importTokenStatus != current.importTokenStatus;
      },
      listener: (context, state) {
        if (state.fetchTokenInfoStatus == FetchTokenInfoStatus.success) {
          _tokenNameTextFieldController.text = state.tokenName;
          _tokenSymbolTextFieldController.text = state.tokenSymbol;
          _tokenDecimalsTextFieldController.text = state.tokenDecimals.toString();
        }
        if (state.importTokenStatus == ImportTokenStatus.success) {
          Navigator.of(context).pop();
        }
        if (state.importTokenStatus == ImportTokenStatus.failure) {
          showSnackBar(
            message: state.errorMessage,
            context: context,
            snackBarType: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.importTokens),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacings.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.tokenContractAddress,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              EthereumAddressTextField(
                controller: _tokenAddressTextFieldController,
                hintText: '0x...',
              ),
              ListenableBuilder(
                listenable: _isValidTokenAddressNotifier,
                builder: (context, child) {
                  if (!_isValidTokenAddressNotifier.value) return SizedBox.shrink();
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _tokenNameTextFieldController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.tokenName,
                          hintText: AppLocalizations.of(context)!.tokenNameHint,
                        ),
                      ),
                      TextField(
                        controller: _tokenSymbolTextFieldController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.tokenSymbol,
                          hintText: AppLocalizations.of(context)!.tokenSymbolHint,
                        ),
                      ),
                      TextField(
                        controller: _tokenDecimalsTextFieldController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.tokenDecimals,
                          hintText: AppLocalizations.of(context)!.tokenDecimalsHint,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BlocBuilder<ImportTokenBloc, ImportTokenState>(
                            builder: (context, state) {
                              return FilledButton(
                                onPressed: state.importTokenStatus == ImportTokenStatus.loading ||
                                        state.importTokenStatus == ImportTokenStatus.success
                                    ? null
                                    : () => context.read<ImportTokenBloc>().add(ImportTokenSubmitted()),
                                child: state.importTokenStatus == ImportTokenStatus.loading
                                    ? Text(AppLocalizations.of(context)!.importingToken)
                                    : Text(
                                        AppLocalizations.of(context)!.importToken,
                                      ),
                              );
                              /* return FilledButton(
                                onPressed: () {},
                                child: Text('Import token'),
                              ); */
                            },
                          ),
                        ],
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
