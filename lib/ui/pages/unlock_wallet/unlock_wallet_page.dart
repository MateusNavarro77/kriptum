import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/reset_wallet/reset_wallet_bloc.dart';
import 'package:kriptum/blocs/unlock_wallet/unlock_wallet_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/shared/utils/show_snack_bar.dart';
import 'package:kriptum/ui/pages/home_wrapper/home_wrapper_page.dart';
import 'package:kriptum/ui/pages/splash/splash_page.dart';
import 'package:kriptum/ui/pages/unlock_wallet/widgets/erase_wallet_dialog.dart';

import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:kriptum/ui/widgets/app_version_text_widget.dart';

class UnlockWalletPage extends StatelessWidget {
  const UnlockWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ResetWalletBloc>(
          create: (context) => injector.get<ResetWalletBloc>(),
        ),
        BlocProvider<UnlockWalletBloc>(
          create: (context) => injector.get<UnlockWalletBloc>(),
        ),
      ],
      child: UnlockWalletView(),
    );
  }
}

class UnlockWalletView extends StatefulWidget {
  const UnlockWalletView({
    super.key,
  });

  @override
  State<UnlockWalletView> createState() => _UnlockWalletViewState();
}

class _UnlockWalletViewState extends State<UnlockWalletView> {
  final _passwordTextController = TextEditingController();

  @override
  void dispose() {
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocConsumer<UnlockWalletBloc, UnlockWalletState>(
              listener: (context, state) {
                if (state is UnlockWalletSuccess) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeWrapperPage(),
                    ),
                    (route) => false,
                  );
                } else if (state is UnlockWalletFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                }
              },
              builder: (context, state) {
                if (state is UnlockWalletInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is UnlockWalletSuccess) {
                  return SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacings.horizontalPadding,
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Welcome Back!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: _passwordTextController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Password'),
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          FilledButton(
                              onPressed: () {
                                context.read<UnlockWalletBloc>().add(
                                      UnlockWalletRequested(
                                        _passwordTextController.text,
                                      ),
                                    );
                              },
                              child: const Text('UNLOCK')),
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            'Wallet won\' unlock? You can ERASE your current wallet and setup a new one',
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                              onPressed: () => _showEraseWalletDialog(context), child: const Text('Reset Wallet'))
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AppVersionTextWidget(),
            )
          ],
        ),
      ),
    );
  }

  void _showEraseWalletDialog(BuildContext context) {
    final bloc = context.read<ResetWalletBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocConsumer<ResetWalletBloc, ResetWalletState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is ResetWalletSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const SplashPage(),
                ),
                (route) => false,
              );
            } else if (state is ResetWalletFailure) {
              showSnackBar(
                message: state.error,
                context: context,
                snackBarType: SnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            return EraseWalletDialog(
              onCancel: () {
                Navigator.of(context).pop();
              },
              onContinue: () {
                bloc.add(ResetWalletRequested());
              },
              isLoading: state is ResetWalletInProgress,
            );
          },
        );
      },
    );
  }
}
