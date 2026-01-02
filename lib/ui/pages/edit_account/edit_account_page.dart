import 'package:flutter/material.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/ui/tokens/spacings.dart';

class EditAccountPage extends StatefulWidget {
  final Account _accountToBeEdited;
  final void Function(Account editedAccount) onAccountEditionCompleted;
  const EditAccountPage({
    super.key,
    required Account accountToBeEdited,
    required this.onAccountEditionCompleted,
  }) : _accountToBeEdited = accountToBeEdited;

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  late final Account _accountToBeEdited;
  late final TextEditingController _aliasNameController;
  @override
  void initState() {
    _accountToBeEdited = widget._accountToBeEdited;
    _aliasNameController = TextEditingController(
      text: _accountToBeEdited.alias,
    );
    super.initState();
  }

  @override
  void dispose() {
    _aliasNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacings.horizontalPadding,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  TextField(
                    controller: _aliasNameController,
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.name),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    initialValue: _accountToBeEdited.address,
                    enabled: false,
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.address),
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.onAccountEditionCompleted(
                        _accountToBeEdited.copyWith(
                          alias: _aliasNameController.text,
                        ),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.save),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
