import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/current_network/current_network_cubit.dart';
import 'package:kriptum/blocs/current_native_balance/current_native_balance_bloc.dart';
import 'package:kriptum/blocs/send_transaction/send_transaction_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/shared/utils/show_snack_bar.dart';
import 'package:kriptum/ui/pages/send_native/widgets/page_title.dart';
import 'package:kriptum/ui/tokens/placeholders.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChooseAmountWidget extends StatelessWidget {
  const ChooseAmountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentNativeBalanceBloc>(
          create: (context) => injector.get<CurrentNativeBalanceBloc>()
            ..add(CurrentNativeBalanceRequested())
            ..add(CurrentNativeBalanceVisibilityRequested()),
        ),
        BlocProvider<CurrentNetworkCubit>(
          create: (context) => injector.get<CurrentNetworkCubit>()..requestCurrentNetwork(),
        ),
      ],
      child: const _ChooseAmountWidget(),
    );
  }
}

class _ChooseAmountWidget extends StatefulWidget {
  const _ChooseAmountWidget();

  @override
  State<_ChooseAmountWidget> createState() => _ChooseAmountWidgetState();
}

class _ChooseAmountWidgetState extends State<_ChooseAmountWidget> {
  final TextEditingController _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        final sendTransactionBloc = context.read<SendTransactionBloc>();
        _amountTextEditingController.text =
            EthereumAmount.fromWei(sendTransactionBloc.state.amount ?? BigInt.from(0)).toEtherString(decimals: 2);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _amountTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CurrentNetworkCubit, CurrentNetworkState>(
          builder: (context, state) {
            if (state is CurrentNetworkLoaded) {
              return PageTitle(
                title: AppLocalizations.of(context)!.amount,
                networkName: state.network.name,
              );
            }
            return const SizedBox.shrink();
          },
        ),
        centerTitle: true,
        leading: TextButton(
            onPressed: () {
              context.read<SendTransactionBloc>().add(ReturnToRecipientSelection());
            },
            child: Text(AppLocalizations.of(context)!.back)),
        actions: [
          TextButton(
            onPressed: () {},
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // GoRouter.of(context).pushReplacement(AppRoutes.home);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      iconAlignment: IconAlignment.end,
                      onPressed: () {},
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      label: BlocBuilder<CurrentNetworkCubit, CurrentNetworkState>(
                        builder: (context, state) {
                          if (state is CurrentNetworkLoaded) {
                            return Text('${state.network.name} ${state.network.ticker}');
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    )
                    //'${currentNetworkController.currentConnectedNetwork?.name} ${currentNetworkController.currentConnectedNetwork?.ticker}')),
                    ),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => _useMax(context), child: Text(AppLocalizations.of(context)!.useMax)))
              ],
            ),
            const SizedBox(
              height: 36,
            ),
            TextField(
              controller: _amountTextEditingController,
              onChanged: (value) {
                // sendAmountController.updateAmountValueInEth(value);
              },
              keyboardType: const TextInputType.numberWithOptions(),
              style: const TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: '0', border: InputBorder.none),
            ),
            const SizedBox(
              height: 24,
            ),
            Builder(builder: (context) {
              final currentNetworkCubit = context.watch<CurrentNetworkCubit>();
              final balanceBloc = context.watch<CurrentNativeBalanceBloc>();

              String ticker = '';
              if (currentNetworkCubit.state is CurrentNetworkLoaded) {
                ticker = (currentNetworkCubit.state as CurrentNetworkLoaded).network.ticker;
              }
              if (ticker.isEmpty || balanceBloc.state.accountBalance == null) {
                return Skeletonizer(child: Text(Placeholders.hiddenBalancePlaceholder));
              }
              return Text(
                  '${AppLocalizations.of(context)!.balance}: ${balanceBloc.state.accountBalance?.toEtherString(decimals: 2)} $ticker');
            }),
            // 'Balance: ${formatEther(accountBalanceController.balance)} ${currentNetworkController.currentConnectedNetwork?.ticker}'),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacings.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocListener<SendTransactionBloc, SendTransactionState>(
                    listenWhen: (previous, current) => previous.errorMessage != current.errorMessage,
                    listener: (context, state) {
                      if (state.errorMessage.isNotEmpty) {
                        showSnackBar(
                          message: state.errorMessage,
                          context: context,
                          snackBarType: SnackBarType.error,
                        );
                      }
                    },
                    child: BlocSelector<SendTransactionBloc, SendTransactionState, AmountValidationStatus>(
                      selector: (state) {
                        return state.amountValidationStatus;
                      },
                      builder: (context, state) {
                        if (state == AmountValidationStatus.validationLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return FilledButton(
                            onPressed: () => _onNextStep(context), child: Text(AppLocalizations.of(context)!.next));
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _useMax(BuildContext context) {
    final balanceBloc = context.read<CurrentNativeBalanceBloc>();
    final balance = balanceBloc.state.accountBalance;
    if (balance != null) {
      _amountTextEditingController.text = balance.toEtherString(decimals: 2);
    }
    // amountTextEditingController.text =
    //     formatEther(accountBalanceController.balance);
    // sendAmountController
    //     .updateAmountValueInEth(amountTextEditingController.text);
  }

  void _onNextStep(BuildContext context) {
    context.read<SendTransactionBloc>().add(
          AdvanceToConfirmation(
            amount: _amountTextEditingController.text,
          ),
        );

    /* if (!BalanceValidatorController.validateBalance(
        amountTextEditingController.text, accountBalanceController.balance)) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            showCloseIcon: true,
            content: const Text('Amount must not exceed account balance!')));

      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ConfirmScreen(
        sendTransactionController: sendTransactionController,
        toAddressController: toAddressController,
        accountBalanceController: accountBalanceController,
        currentAccountController: currentAccountController,
        currentNetworkController: currentNetworkController,
        sendAmountController: sendAmountController,
      ),
    )); */
  }
}
