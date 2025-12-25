import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jazzicon/jazzicon.dart';
import 'package:kriptum/blocs/current_account/current_account_cubit.dart';
import 'package:kriptum/blocs/current_network/current_network_cubit.dart';
import 'package:kriptum/blocs/current_native_balance/current_native_balance_bloc.dart';
import 'package:kriptum/blocs/send_transaction/send_transaction_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/shared/utils/format_address.dart';
import 'package:kriptum/shared/utils/show_snack_bar.dart';
import 'package:kriptum/ui/pages/send_native/widgets/page_title.dart';
import 'package:kriptum/ui/pages/send_native/widgets/transaction_info_dialog.dart';
import 'package:kriptum/ui/tokens/spacings.dart';

class ConfirmTransactionWidget extends StatelessWidget {
  const ConfirmTransactionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentNativeBalanceBloc>(
          create: (context) => injector.get<CurrentNativeBalanceBloc>()..add(CurrentNativeBalanceRequested()),
        ),
        BlocProvider<CurrentNetworkCubit>(
          create: (context) => injector.get<CurrentNetworkCubit>()..requestCurrentNetwork(),
        ),
        BlocProvider<CurrentAccountCubit>(
          create: (context) => injector.get<CurrentAccountCubit>()..requestCurrentAccount(),
        ),
      ],
      child: _ConfirmTransactionWidget(),
    );
  }
}

class _ConfirmTransactionWidget extends StatelessWidget {
  const _ConfirmTransactionWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            context.read<SendTransactionBloc>().add(ReturnToAmountSelection());
          },
          child: const Text('Back'),
        ),
        title: PageTitle(
          title: 'Confirm',
          networkName: '',
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //GoRouter.of(context).pushReplacement(AppRoutes.home);
              },
              child: const Text('Cancel'),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacings.horizontalPadding,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'From:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ListTile(
                    // shape: Border.all(

                    //   color: Theme.of(context).hintColor
                    // ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Theme.of(context).hintColor),
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    trailing: Builder(builder: (context) {
                      final balanceBloc = context.watch<CurrentNativeBalanceBloc>();
                      final networksCubit = context.watch<CurrentNetworkCubit>();
                      final balance = balanceBloc.state.accountBalance;
                      final networkState = networksCubit.state;
                      String ticker = '';
                      if (networkState is CurrentNetworkLoaded) {
                        ticker = networkState.network.ticker;
                      }
                      if (ticker.isEmpty || balance == null) return SizedBox.shrink();
                      return Text(
                          //'${formatEther(accountBalanceController.balance)} ${currentNetworkController.currentConnectedNetwork?.ticker}',
                          '${balance.toEtherString(decimals: 2)} $ticker',
                          style: Theme.of(context).textTheme.bodyLarge);
                    }),
                    leading: BlocBuilder<CurrentAccountCubit, CurrentAccountState>(
                      builder: (context, state) {
                        if (state.account == null) return SizedBox.shrink();
                        return Jazzicon.getIconWidget(
                          size: 30,
                          Jazzicon.getJazziconData(
                            30,
                            address: state.account?.address,
                          ),
                        );
                      },
                    ),
                    title: BlocBuilder<CurrentAccountCubit, CurrentAccountState>(
                      builder: (context, state) {
                        if (state.account == null) return SizedBox.shrink();
                        return Text(
                          state.account!.alias ?? 'From',
                        );
                      },
                    ),
                    subtitle: BlocBuilder<CurrentAccountCubit, CurrentAccountState>(
                      builder: (context, state) {
                        if (state.account == null) return SizedBox.shrink();
                        return Text(
                          formatAddress(state.account!.address),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'To',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  BlocSelector<SendTransactionBloc, SendTransactionState, String?>(
                    selector: (state) {
                      return state.toAddress;
                    },
                    builder: (context, state) {
                      return ListTile(
                        title: Text(
                          formatAddress(state!),
                        ),
                        // shape: Border.all(

                        //   color: Theme.of(context).hintColor
                        // ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Theme.of(context).hintColor),
                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                        leading: Jazzicon.getIconWidget(
                          size: 30,
                          Jazzicon.getJazziconData(
                            30,
                            address: state,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              Expanded(
                  child: ListView(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'AMOUNT',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Builder(builder: (context) {
                    final amount = context.select<SendTransactionBloc, BigInt?>((bloc) => bloc.state.amount);
                    final currentNetworkCubit = context.watch<CurrentNetworkCubit>();
                    String ticker = '';
                    final networkState = currentNetworkCubit.state;
                    if (networkState is CurrentNetworkLoaded) {
                      ticker = networkState.network.ticker;
                    }
                    if (ticker.isEmpty || amount == null) {
                      return SizedBox.shrink();
                    }

                    return Text(
                      '${EthereumAmount.fromWei(amount).toEtherString(decimals: 2)} \n $ticker',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    );
                  })
                ],
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocConsumer<SendTransactionBloc, SendTransactionState>(
                    listenWhen: (previous, current) => previous.status != current.status,
                    listener: (context, state) async {
                      final accountCubit = context.read<CurrentAccountCubit>();
                      final networkCubit = context.read<CurrentNetworkCubit>();
                      final sendTransactionBloc = context.read<SendTransactionBloc>();
                      if (state.status == SendTransactionStatus.confirmationSuccess) {
                        final networkState = networkCubit.state;
                        final sendTransactionState = sendTransactionBloc.state;
                        final accountState = accountCubit.state;
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return TransactionInfoDialog(
                              network: (networkState as CurrentNetworkLoaded).network,
                              from: accountState.account!,
                              toAddress: sendTransactionState.toAddress!,
                              transactionHash: sendTransactionState.txHash!,
                              amount: sendTransactionState.amount!,
                              dateTime: state.confirmationTime!,
                              followOnBlockExplorerUrl: sendTransactionState.followOnBlockExplorerUrl,
                              onPop: () {},
                            );
                          },
                        );
                      }
                      if (state.status == SendTransactionStatus.confirmationError) {
                        showSnackBar(
                          message: state.errorMessage,
                          context: context,
                          snackBarType: SnackBarType.error,
                        );
                      }
                    },
                    buildWhen: (previous, current) => previous.status != current.status,
                    builder: (context, state) {
                      final loading = state.status == SendTransactionStatus.confirmationLoading;
                      if (loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return FilledButton(
                        onPressed: () => _triggerSendTransaction(context),
                        child: Text('Send'),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _triggerSendTransaction(BuildContext context) async {
    context.read<SendTransactionBloc>().add(SendTransactionRequest());
  }
}
