import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriptum/blocs/contacts/contacts_bloc.dart';
import 'package:kriptum/config/di/injector.dart';

import 'package:kriptum/domain/models/contact.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/shared/utils/show_snack_bar.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:kriptum/ui/widgets/ethereum_address_text_field.dart';

class EditContactPage extends StatelessWidget {
  final Contact contact;
  const EditContactPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsBloc>(
      create: (context) => injector.get<ContactsBloc>(),
      child: _EditContactPage(contact: contact),
    );
  }
}

class _EditContactPage extends StatefulWidget {
  final Contact contact;

  const _EditContactPage({
    required this.contact,
  });

  @override
  State<_EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<_EditContactPage> {
  // A GlobalKey to uniquely identify the Form widget and allow validation.
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields. They are initialized in initState and disposed in dispose.
  late final TextEditingController _nameTextController;
  late final TextEditingController _addressTextController;

  // A mutable copy of the contact to hold edits.
  late Contact _contactToBeEdited;

  // State variable to toggle between viewing and editing modes.
  bool _isViewOnlyMode = true;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers and the contact copy with the initial data from the widget.
    // This is done in initState because it's called only once when the state object is created.
    _nameTextController = TextEditingController(text: widget.contact.name);
    _addressTextController = TextEditingController(text: widget.contact.address);
    _contactToBeEdited = widget.contact.copyWith();
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the widget tree
    // to free up resources and prevent memory leaks.
    _nameTextController.dispose();
    _addressTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editContact),
        actions: [
          IconButton(
            onPressed: _toggleViewOnlyMode,
            // The icon changes based on the current mode.
            icon: Icon(_isViewOnlyMode ? Icons.edit : Icons.cancel),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Spacings.horizontalPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                AppLocalizations.of(context)!.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextFormField(
                readOnly: _isViewOnlyMode,
                onChanged: (value) => _contactToBeEdited.name = value,
                //validator: (value) =>
                //    ContactValidatorController.validateName(value ?? ''),
                controller: _nameTextController,
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.name),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.address,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              EthereumAddressTextField(
                controller: _addressTextController,
                readOnly: _isViewOnlyMode,
              ),
              const SizedBox(height: 24),
              // Conditionally render the action buttons based on the mode.
              if (!_isViewOnlyMode)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocConsumer<ContactsBloc, ContactsState>(
                      listenWhen: (previous, current) => previous.updateStatus != current.updateStatus,
                      listener: (context, state) {
                        if (state.updateStatus == ContactUpdateStatus.success) {
                          Navigator.of(context).pop();
                        }
                        if (state.updateStatus == ContactUpdateStatus.error) {
                          showSnackBar(
                            message: state.errorMessage,
                            context: context,
                            snackBarType: SnackBarType.error,
                          );
                        }
                      },
                      buildWhen: (previous, current) => previous.updateStatus != current.updateStatus,
                      builder: (context, state) {
                        final loading = state.updateStatus == ContactUpdateStatus.loading;
                        return FilledButton(
                          onPressed: loading ? null : () => _triggerEditContact(context),
                          child: Text(AppLocalizations.of(context)!.editContact),
                        );
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => _showDeleteContactModal(context),
                      child: Text(AppLocalizations.of(context)!.delete),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleViewOnlyMode() {
    // Use setState to rebuild the widget with the new mode value.
    setState(() {
      _isViewOnlyMode = !_isViewOnlyMode;
      // If we cancel the edit, revert the text fields to the original contact data.
      if (_isViewOnlyMode) {
        _nameTextController.text = widget.contact.name;
        _addressTextController.text = widget.contact.address;
        _contactToBeEdited = widget.contact.copyWith();
      }
    });
  }

  Future<void> _triggerEditContact(BuildContext context) async {
    // Validate the form before proceeding.
    if (!_formKey.currentState!.validate()) return;
    context.read<ContactsBloc>().add(
          ContactUpdateRequested(
            updatedContact: _contactToBeEdited,
          ),
        );
  }

  void _showDeleteContactModal(BuildContext context) {
    final buttonTextSize = Theme.of(context).textTheme.bodyLarge?.fontSize;
    final bloc = context.read<ContactsBloc>();
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Spacings.horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(fontSize: buttonTextSize),
              ),
            ),
            BlocConsumer<ContactsBloc, ContactsState>(
              bloc: bloc,
              listenWhen: (previous, current) => previous.deletionStatus != current.deletionStatus,
              listener: (context, state) {
                if (state.deletionStatus == ContactDeletionStatus.error) {
                  showSnackBar(
                    message: state.errorMessage,
                    context: context,
                    snackBarType: SnackBarType.error,
                  );
                }
                if (state.deletionStatus == ContactDeletionStatus.success) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              builder: (context, state) => TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed:
                    state.deletionStatus == ContactDeletionStatus.loading ? null : () => _triggerDeleteContact(bloc),
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(fontSize: buttonTextSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _triggerDeleteContact(ContactsBloc contactsBloc) async {
    contactsBloc.add(
      ContactDeletionRequested(
        contactId: _contactToBeEdited.id!,
      ),
    );
  }
}
