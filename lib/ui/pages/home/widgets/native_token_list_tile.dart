import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/current_native_balance/current_native_balance_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/ui/pages/home/widgets/asset_list_tile.dart';
import 'package:kriptum/ui/pages/token/token_page.dart';

class NativeTokenListTile extends StatelessWidget {
  const NativeTokenListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentNativeBalanceBloc>(
      create: (context) => injector.get<CurrentNativeBalanceBloc>()
        ..add(CurrentNativeBalanceRequested())
        ..add(CurrentNativeBalanceVisibilityRequested()),
      child: const _NativeTokenListTile(),
    );
  }
}

class _NativeTokenListTile extends StatelessWidget {
  const _NativeTokenListTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentNativeBalanceBloc, CurrentNativeBalanceState>(
      builder: (context, state) {
        final error = state.status == CurrentNativeBalanceStatus.error;
        final isLoading = state.status == CurrentNativeBalanceStatus.loading;
        final isVisible = state.isVisible;
        final assetName = state.ticker;
        final assetTicker = state.ticker;
        final assetBalance = state.accountBalance?.toEther(fractionDigitAmount: 4) ?? '0.0000';
        return AssetListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return TokenPage();
                },
              ),
            );
          },
          name: assetName,
          ticker: assetTicker,
          assetBalance: assetBalance,
          hideBalance: !isVisible,
          loadingBalance: isLoading,
          errorLoadingBalance: error,
        );
      },
    );
  }
}
