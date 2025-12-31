import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/create_new_wallet/create_new_wallet_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/ui/pages/create_new_wallet/widgets/create_password_widget.dart';
import 'package:kriptum/ui/pages/create_new_wallet/widgets/secure_wallet_widget.dart';
import 'package:kriptum/ui/pages/create_new_wallet/widgets/write_on_paper_widget.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:kriptum/ui/widgets/main_title_app_bar_widget.dart';

class CreateNewWalletPage extends StatelessWidget {
  const CreateNewWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateNewWalletBloc>(
      create: (context) => injector.get<CreateNewWalletBloc>(),
      child: const CreateNewWalletView(),
    );
  }
}

class CreateNewWalletView extends StatelessWidget {
  const CreateNewWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainTitleAppBarWidget(),
      body: BlocConsumer<CreateNewWalletBloc, CreateNewWalletState>(
        listener: (context, state) {
          if (state.status == CreateNewWalletStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          }
        },
        builder: (context, state) {
          switch (state.step) {
            case 1:
              return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Spacings.horizontalPadding,
                  ),
                  child: const CreatePasswordWidget());
            case 2:
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacings.horizontalPadding,
                ),
                child: const SecureWalletStep2Screen(),
              );
            case 3:
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacings.horizontalPadding,
                ),
                child: const WriteOnPaperStep3Screen(),
              );

            default:
              return Center(child: Text(AppLocalizations.of(context)!.unknownStep));
          }
        },
      ),
    );
  }
}
