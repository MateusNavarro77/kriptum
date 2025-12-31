import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jazzicon/jazzicon.dart';
import 'package:kriptum/blocs/contacts/contacts_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/models/contact.dart';
import 'package:kriptum/l10n/app_localizations.dart';
import 'package:kriptum/shared/utils/format_address.dart';
import 'package:kriptum/ui/pages/add_contact/add_contact_page.dart';
import 'package:kriptum/ui/pages/edit_contact/edit_contact_page.dart';
import 'package:kriptum/ui/tokens/spacings.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsBloc>(
      create: (context) => injector.get<ContactsBloc>()..add(ContactsRequested()),
      child: _ContactsView(),
    );
  }
}

class _ContactsView extends StatelessWidget {
  const _ContactsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.contacts),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Spacings.horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: BlocBuilder<ContactsBloc, ContactsState>(
                  builder: (context, state) {
                    if (state.status == ContactsStatus.loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.filteredContacts.isEmpty) {
                      return Center(
                        child: Text(AppLocalizations.of(context)!.noContacts),
                      );
                    }

                    final grouped = state.groupedByFirstLetter;
                    final sortedKeys = grouped.keys.toList()..sort();

                    return ListView.builder(
                      itemCount: sortedKeys.fold<int>(0, (total, key) => total + grouped[key]!.length + 1),
                      itemBuilder: (context, index) {
                        int currentIndex = 0;

                        for (final key in sortedKeys) {
                          // Section Header
                          if (index == currentIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                              child: Text(
                                key,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            );
                          }

                          final contacts = grouped[key]!;
                          final contactIndex = index - currentIndex - 1;

                          if (contactIndex < contacts.length) {
                            final contact = contacts[contactIndex];
                            return ListTile(
                              onTap: () => _navigateToEditContactPage(context, contact),
                              contentPadding: EdgeInsets.zero,
                              minLeadingWidth: 40,
                              leading: Jazzicon.getIconWidget(
                                Jazzicon.getJazziconData(40, address: contact.address),
                              ),
                              title: Text(contact.name),
                              subtitle: Text(formatAddress(contact.address)),
                            );
                          }

                          currentIndex += contacts.length + 1;
                        }

                        return const SizedBox.shrink(); // fallback
                      },
                    );
                  },
                ),
/*               child: ListenableBuilder(
                listenable: widget.contactsController,
                builder: (context, child) {
                  if (widget.contactsController.contacts.isEmpty) {
                    return Center(
                      child: Text('No Contacts'),
                    );
                  }
                  return ListView.builder(
                    itemCount: widget.contactsController.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = widget.contactsController.contacts[index];

                      return ListTile(
                        onTap: () => _navigateToEditContactPage(
                            context, widget.contactsController.contacts[index]),
                        contentPadding: EdgeInsets.zero,
                        minLeadingWidth: 40,
                        leading: Jazzicon.getIconWidget(
                            Jazzicon.getJazziconData(40,
                                address: contact.address)),
                        title: Text(contact.name),
                        subtitle: Text(formatAddress(contact.address)),
                      );
                    },
                  );
                },
              ), */
              ),
              FilledButton(
                  onPressed: () {
                    _navigateToAddContactPage(context);
                  },
                  child: Text(AppLocalizations.of(context)!.addContact))
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddContactPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddContactPage(),
      ),
    );
  }

  void _navigateToEditContactPage(BuildContext context, Contact contact) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditContactPage(contact: contact),
      ),
    );
  }
}
