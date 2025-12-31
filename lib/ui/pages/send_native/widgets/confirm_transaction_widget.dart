import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jazzicon/jazzicon.dart';
import 'package:kriptum/blocs/current_account/current_account_cubit.dart';
import 'package:kriptum/blocs/current_network/current_network_cubit.dart';
import 'package:kriptum/blocs/current_native_balance/current_native_balance_bloc.dart';
import 'package:kriptum/blocs/send_transaction/send_transaction_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/l10n/app_localizations.dart';
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
          child: Text(AppLocalizations.of(context)!.back),
        ),
        title: PageTitle(
          title: AppLocalizations.of(context)!.confirm,
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
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacings.horizontalPadding, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16,
                    children: [
                      Builder(
                        builder: (context) {
                          final amountToSend =
                              context.select<SendTransactionBloc, BigInt?>((bloc) => bloc.state.amount);
                          final ticker = context.select<CurrentNetworkCubit, String>((cubit) {
                            final state = cubit.state;
                            if (state is CurrentNetworkLoaded) {
                              return state.network.ticker;
                            }
                            return '';
                          });
                          if (amountToSend == null || ticker.isEmpty) {
                            return SizedBox.shrink();
                          }
                          return Text(
                            '${EthereumAmount.fromWei(amountToSend).toEtherString(decimals: 4)} $ticker',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          );
                        },
                      ),
                      TileContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.from,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            BlocBuilder<CurrentAccountCubit, CurrentAccountState>(
                              builder: (context, state) {
                                if (state.account == null) return const SizedBox.shrink();
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 8,
                                  children: [
                                    Jazzicon.getIconWidget(
                                      size: 24,
                                      Jazzicon.getJazziconData(
                                        24,
                                        address: state.account?.address,
                                      ),
                                    ),
                                    Text(
                                      formatAddress(state.account!.address),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      TileContainer(
                        child: BlocSelector<SendTransactionBloc, SendTransactionState, String?>(
                          selector: (state) {
                            return state.toAddress;
                          },
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.to,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 8,
                                  children: [
                                    Jazzicon.getIconWidget(
                                      size: 24,
                                      Jazzicon.getJazziconData(
                                        24,
                                        address: state,
                                      ),
                                    ),
                                    Text(
                                      formatAddress(state!),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      TileContainer(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.gasPrice,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    final gasPrice =
                                        context.select<SendTransactionBloc, BigInt?>((bloc) => bloc.state.gasPrice);
                                    final ticker = context.select<CurrentNetworkCubit, String>((cubit) {
                                      final state = cubit.state;
                                      if (state is CurrentNetworkLoaded) {
                                        return state.network.ticker;
                                      }
                                      return '';
                                    });
                                    if (gasPrice == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return Text(
                                      '${EthereumAmount.fromWei(gasPrice).toEtherString(decimals: 18)} $ticker',
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.networkFee,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    final gasFee =
                                        context.select<SendTransactionBloc, BigInt?>((bloc) => bloc.state.gasFee);
                                    final ticker = context.select<CurrentNetworkCubit, String>((cubit) {
                                      final state = cubit.state;
                                      if (state is CurrentNetworkLoaded) {
                                        return state.network.ticker;
                                      }
                                      return '';
                                    });
                                    if (gasFee == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return Text(
                                      '${EthereumAmount.fromWei(gasFee).toEtherString()} $ticker',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )

                      // ...List.generate(
                      //   ,
                      //   (index) => ListTile(
                      //     title: Text('Item $index'),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacings.horizontalPadding,
              ),
              child: BlocConsumer<SendTransactionBloc, SendTransactionState>(
                listenWhen: (previous, current) => previous.status != current.status,
                listener: (context, state) {
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
                builder: (context, state) {
                  if (state.status == SendTransactionStatus.confirmationLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                      ),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                          onPressed: () {
                            _triggerSendTransaction(context);
                          },
                          child: Text(AppLocalizations.of(context)!.confirm),
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _triggerSendTransaction(BuildContext context) async {
    context.read<SendTransactionBloc>().add(SendTransactionRequest());
  }
}

class TileContainer extends StatelessWidget {
  const TileContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
