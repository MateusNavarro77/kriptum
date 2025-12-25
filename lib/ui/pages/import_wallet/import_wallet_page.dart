// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/import_wallet/import_wallet_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/factories/password_factory.dart';
import 'package:kriptum/domain/value_objects/mnemonic.dart';
import 'package:kriptum/ui/pages/home_wrapper/home_wrapper_page.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:kriptum/ui/widgets/main_title_app_bar_widget.dart';

//test test test test test test test test test test test junk

class ImportWalletPage extends StatelessWidget {
  const ImportWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImportWalletBloc>(
      create: (context) => injector.get<ImportWalletBloc>(),
      child: _ImportWalletView(),
    );
  }
}

class _ImportWalletView extends StatefulWidget {
  const _ImportWalletView();

  @override
  State<_ImportWalletView> createState() => _ImportWalletViewState();
}

class _ImportWalletViewState extends State<_ImportWalletView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _mnemonicTextController = TextEditingController();

  final _passwordTextController = TextEditingController();

  final _confirmPasswordTextController = TextEditingController();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _mnemonicTextController.dispose();
    _confirmPasswordTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainTitleAppBarWidget(),
      body: BlocConsumer<ImportWalletBloc, ImportWalletState>(
        listener: (context, state) {
          if (state is ImportWalletSuccess) {
            _navigateToHome(context);
          }
        },
        builder: (context, state) {
          if (state is ImportWalletLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ImportWalletSuccess) {
            return SizedBox.shrink();
          }
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacings.horizontalPadding,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Import from Secret Recovery Phrase',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _mnemonicTextController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        final result = Mnemonic.create(value ?? '');
                        if (result.isFailure) return result.failure;
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Enter your Secret Recovery Phrase',
                          label: Text('Secret Recovery Phrase'),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordTextController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) {
                        final result = injector.get<PasswordFactory>().create(password ?? '');
                        if (result.isFailure) return result.failure;
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'New Password',
                        label: Text('New Password'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _confirmPasswordTextController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (confirmPassword) {
                        if (confirmPassword != _passwordTextController.text) {
                          return 'Passwords don\'t match';
                        }
                        final result = injector.get<PasswordFactory>().create(confirmPassword ?? '');
                        if (result.isFailure) return result.failure;
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Confirm Password',
                          helperText: 'Must be at least 8 characters',
                          label: Text('Confirm Password'),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                        onPressed: () => _triggerImportWallet(context),

                        //onPressed: () {},
                        child: const Text('IMPORT'))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _triggerImportWallet(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ImportWalletBloc>().add(
          ImportWalletRequested(
            mnemonicPhrase: _mnemonicTextController.text,
            password: _passwordTextController.text,
          ),
        );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeWrapperPage(),
      ),
      (route) => false,
    );
  }
}
