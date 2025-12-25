import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/current_network/current_network_cubit.dart';
import 'package:kriptum/blocs/current_native_balance/current_native_balance_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/ui/tokens/placeholders.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MainBalanceViewer extends StatelessWidget {
  const MainBalanceViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentNativeBalanceBloc>(
          create: (context) => injector.get<CurrentNativeBalanceBloc>()
            ..add(
              CurrentNativeBalanceRequested(),
            )
            ..add(
              CurrentNativeBalanceRequested(),
            ),
        ),
        BlocProvider<CurrentNetworkCubit>(
          create: (context) => injector.get<CurrentNetworkCubit>()..requestCurrentNetwork(),
        )
      ],
      child: const _MainBalanceViewer(),
    );
  }
}

class _MainBalanceViewer extends StatelessWidget {
  const _MainBalanceViewer();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final currentNetworkCubit = context.watch<CurrentNetworkCubit>();
      final nativeBalanceBloc = context.watch<CurrentNativeBalanceBloc>();
      final currentNetworkState = currentNetworkCubit.state;
      final nativeBalanceState = nativeBalanceBloc.state;
      if (currentNetworkState is! CurrentNetworkLoaded) return SizedBox.shrink();
      String content = '';
      switch (nativeBalanceState.status) {
        case CurrentNativeBalanceStatus.error:
          content = nativeBalanceState.errorMessage ?? 'An error occurred';
          break;
        case CurrentNativeBalanceStatus.initial:
        case CurrentNativeBalanceStatus.loading:
          content = 'Loading...';
          break;
        case CurrentNativeBalanceStatus.loaded:
          content = nativeBalanceState.accountBalance!.toEtherString(decimals: 5);
          break;
      }
      bool isVisible = nativeBalanceState.isVisible;
      content = '$content ${currentNetworkState.network.ticker}';
      if (!isVisible) {
        content = Placeholders.hiddenBalancePlaceholder;
      }
      return Skeletonizer(
        enabled: nativeBalanceState.status == CurrentNativeBalanceStatus.loading,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                content,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<CurrentNativeBalanceBloc>().add(
                      ToggleCurrentNativeBalanceVisibility(isVisible: !isVisible),
                    );
              },
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ],
        ),
      );
    });
  }
}
