import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/add_contact/add_contact_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/models/contact.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:kriptum/ui/widgets/ethereum_address_text_field.dart';

class AddContactPage extends StatelessWidget {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddContactBloc>(
      create: (context) => injector.get<AddContactBloc>(),
      child: const _AddContactView(),
    );
  }
}

class _AddContactView extends StatefulWidget {
  const _AddContactView();

  @override
  State<_AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<_AddContactView> {
  final _nameTextController = TextEditingController();

  final _addressTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameTextController.dispose();
    _addressTextController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.titleMedium;
    return BlocListener<AddContactBloc, AddContactState>(
      listener: (context, state) {
        if (state is AddContactError) {
          _onError(context, state.message);
          return;
        }
        if (state is AddContactSuccess) {
          _onSuccess(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addContactPage_title),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacings.horizontalPadding,
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    AppLocalizations.of(context)!.addContactPage_name,
                    style: labelStyle,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.cannotBeEmpty;
                      }
                      return null;
                    },
                    controller: _nameTextController,
                    decoration: InputDecoration(hintText: AppLocalizations.of(context)!.addContactPage_name),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(AppLocalizations.of(context)!.addContactPage_address, style: labelStyle),
                  EthereumAddressTextField(controller: _addressTextController),
                  const SizedBox(
                    height: 24,
                  ),
                  FilledButton(
                      onPressed: () => _triggerAddContact(context),
                      child: Text(AppLocalizations.of(context)!.addContactPage_addContactBtnText))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _triggerAddContact(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    context.read<AddContactBloc>().add(
          AddContactRequested(
            contact: Contact(
              name: _nameTextController.text,
              address: _addressTextController.text,
            ),
          ),
        );
  }

  void _onSuccess(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}
