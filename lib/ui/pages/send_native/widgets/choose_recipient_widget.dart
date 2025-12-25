import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jazzicon/jazzicon.dart';
import 'package:kriptum/blocs/account_list/account_list_bloc.dart';
import 'package:kriptum/blocs/contacts/contacts_bloc.dart';
import 'package:kriptum/blocs/current_account/current_account_cubit.dart';
import 'package:kriptum/blocs/current_network/current_network_cubit.dart';
import 'package:kriptum/blocs/current_native_balance/current_native_balance_bloc.dart';
import 'package:kriptum/blocs/send_transaction/send_transaction_bloc.dart';
import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/shared/utils/show_snack_bar.dart';
import 'package:kriptum/ui/pages/home/widgets/accounts_modal.dart';
import 'package:kriptum/ui/pages/send_native/widgets/page_title.dart';
import 'package:kriptum/ui/tokens/placeholders.dart';
import 'package:kriptum/ui/tokens/spacings.dart';
import 'package:kriptum/ui/widgets/account_tile_widget.dart';
import 'package:kriptum/ui/widgets/ethereum_address_text_field.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChooseRecipientWidget extends StatelessWidget {
  const ChooseRecipientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrentAccountCubit>(
          create: (context) => injector.get<CurrentAccountCubit>()..requestCurrentAccount(),
        ),
        BlocProvider<CurrentNativeBalanceBloc>(
          create: (context) => injector.get<CurrentNativeBalanceBloc>()
            ..add(CurrentNativeBalanceRequested())
            ..add(CurrentNativeBalanceVisibilityRequested()),
        ),
        BlocProvider<CurrentNetworkCubit>(
          create: (context) => injector.get<CurrentNetworkCubit>()..requestCurrentNetwork(),
        ),
        BlocProvider<AccountListBloc>(
          create: (context) => injector.get<AccountListBloc>()..add(AccountListRequested()),
        ),
        BlocProvider<ContactsBloc>(
          create: (context) => injector.get<ContactsBloc>()
            ..add(
              ContactsRequested(),
            ),
        ),
      ],
      child: const _ChooseRecipientWidget(),
    );
  }
}

class _ChooseRecipientWidget extends StatefulWidget {
  const _ChooseRecipientWidget();

  @override
  State<_ChooseRecipientWidget> createState() => _ChooseRecipientWidgetState();
}

class _ChooseRecipientWidgetState extends State<_ChooseRecipientWidget> {
  final _toAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        final bloc = context.read<SendTransactionBloc>();
        _toAddressController.text = bloc.state.toAddress ?? '';
        _toAddressController.addListener(
          () {
            bloc.add(ToAddressChanged(toAddress: _toAddressController.text));
          },
        );
      },
    );
    /* SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        final bloc = context.read<SendTransactionBloc>();
        bloc.add(ToAddressChanged(toAddress: _toAddressController.text));
      },
    );
    _toAddressController.addListener(
      () {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) {
            context
                .read<SendTransactionBloc>()
                .add(ToAddressChanged(toAddress: _toAddressController.text));
          },
        );
      },
    ); */
    super.initState();
  }

  @override
  void dispose() {
    _toAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'))
        ],
        title: BlocBuilder<CurrentNetworkCubit, CurrentNetworkState>(
          builder: (context, state) {
            String content = '';
            if (state is CurrentNetworkLoaded) {
              content = state.network.name;
            }
            return PageTitle(
              title: 'Send to',
              networkName: content,
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacings.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'From: ',
                        style: TextStyle(fontSize: 22),
                      ),
                      Flexible(
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              isScrollControlled: true,
                              showDragHandle: true,
                              builder: (context) {
                                return const AccountsModal();
                              },
                            );
                          },
                          leading: BlocConsumer<CurrentAccountCubit, CurrentAccountState>(
                            builder: (context, state) {
                              if (state.account == null) {
                                return SizedBox.shrink();
                              }
                              return Jazzicon.getIconWidget(
                                Jazzicon.getJazziconData(
                                  40,
                                  address: state.account?.address,
                                ),
                              );
                            },
                            listener: (BuildContext context, CurrentAccountState state) {
                              context.read<SendTransactionBloc>().add(
                                    ToAddressChanged(toAddress: _toAddressController.text),
                                  );
                            },
                          ),
                          title: BlocBuilder<CurrentAccountCubit, CurrentAccountState>(
                            builder: (context, state) {
                              if (state.account == null) {
                                return SizedBox.shrink();
                              }
                              return Text(state.account?.alias ?? '');
                            },
                          ),
                          subtitle: BlocBuilder<CurrentNativeBalanceBloc, CurrentNativeBalanceState>(
                            builder: (context, state) {
                              String content = '';
                              switch (state.status) {
                                case CurrentNativeBalanceStatus.loading:
                                  content = '........';
                                  break;
                                case CurrentNativeBalanceStatus.loaded:
                                  content = '${state.accountBalance?.toEtherString(decimals: 5)} ${state.ticker}';
                                  break;
                                case CurrentNativeBalanceStatus.error:
                                  content = 'error';
                                default:
                              }
                              if (!state.isVisible) {
                                content = Placeholders.hiddenBalancePlaceholder;
                              }
                              return Skeletonizer(
                                enabled: state.status == CurrentNativeBalanceStatus.loading,
                                child: Text(content),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'To: ',
                        style: TextStyle(fontSize: 22),
                      ),
                      Flexible(
                        child: Form(
                          key: _formKey,
                          child: BlocBuilder<SendTransactionBloc, SendTransactionState>(
                            builder: (context, state) {
                              return EthereumAddressTextField(
                                controller: _toAddressController,
                                inputDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    errorText: state.toAddressEqualsCurrentAccount ? 'Can\'t send to yourself' : null),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final accountsState = context.watch<AccountListBloc>().state;
                    final contactsState = context.watch<ContactsBloc>().state;
                    return ListView(
                      children: [
                        Text(
                          'Your Accounts',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        ...accountsState.accounts.map(
                          (e) => AccountTileWidget(
                            onSelected: () {
                              _toAddressController.text = e.address;
                            },
                            account: e,
                            onOptionsMenuSelected: () {},
                          ),
                        ),
                        Text(
                          'Contacts',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        ...contactsState.contacts.map(
                          (contact) => AccountTileWidget(
                            onSelected: () {
                              _toAddressController.text = contact.address;
                            },
                            //GAMBIARRA
                            account: Account(
                              accountIndex: 0,
                              address: contact.address,
                              encryptedJsonWallet: '',
                              alias: contact.name,
                            ),
                            onOptionsMenuSelected: () {},
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocBuilder<SendTransactionBloc, SendTransactionState>(
                    buildWhen: (previous, current) =>
                        previous.toAddressEqualsCurrentAccount != current.toAddressEqualsCurrentAccount,
                    builder: (context, state) {
                      final isBtnVisible = !state.toAddressEqualsCurrentAccount;
                      return FilledButton(
                        onPressed: isBtnVisible
                            ? () {
                                if (!_formKey.currentState!.validate()) {
                                  showSnackBar(
                                    message: 'Must send to a address',
                                    context: context,
                                    snackBarType: SnackBarType.error,
                                  );
                                  return;
                                }
                                context.read<SendTransactionBloc>().add(
                                      AdvanceToAmountSelection(
                                        toAddress: _toAddressController.text,
                                      ),
                                    );
                              }
                            : null,
                        child: const Text('Next'),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
