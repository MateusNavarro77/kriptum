import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/create_new_wallet/create_new_wallet_bloc.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/ui/widgets/linear_check_in_progress_bar_widget.dart';

class CreatePasswordWidget extends StatelessWidget {
  const CreatePasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNewWalletBloc, CreateNewWalletState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == CreateNewWalletStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Form(
            //key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearCheckInProgressBar(
                  currentDot: 1,
                  //currentDot: _createWalletStepsController.step + 1,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  AppLocalizations.of(context)!.createPassword,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  AppLocalizations.of(context)!.passwordUnlockDeviceOnly,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  // controller: passwordTextController,
                  // validator: (password) =>
                  //     PasswordValidatorController.validLength(password),
                  onChanged: (password) {
                    context.read<CreateNewWalletBloc>().add(
                          PasswordChangedEvent(password: password),
                        );
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.newPassword), border: const OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  // controller: confirmPasswordTextController,
                  //validator: (confirmPassword) =>
                  // PasswordValidatorController.validLength(confirmPassword),
                  onChanged: (confirmPassword) {
                    context.read<CreateNewWalletBloc>().add(
                          ConfirmPasswordChangedEvent(
                            confirmPassword: confirmPassword,
                          ),
                        );
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      helperText: AppLocalizations.of(context)!.mustBeAtLeast8Chars,
                      label: Text(AppLocalizations.of(context)!.confirmPassword),
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 24,
                ),
                FilledButton(
                    onPressed: () {
                      context.read<CreateNewWalletBloc>().add(
                            AdvanceToStep2Event(),
                          );
                    },
                    //onPressed: () => _triggerCreateWallet(context),
                    child: Text(AppLocalizations.of(context)!.createWallet)),
              ],
            ),
          ),
        );
      },
    );
  }
}
