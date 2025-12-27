import 'package:kriptum/blocs/account_list/account_list_bloc.dart';
import 'package:kriptum/blocs/add_contact/add_contact_bloc.dart';
import 'package:kriptum/blocs/add_hd_wallet_account/add_hd_wallet_account_bloc.dart';
import 'package:kriptum/blocs/app_boot/app_boot_bloc.dart';
import 'package:kriptum/blocs/balances/balances_bloc.dart';
import 'package:kriptum/blocs/contacts/contacts_bloc.dart';
import 'package:kriptum/blocs/create_new_wallet/create_new_wallet_bloc.dart';
import 'package:kriptum/blocs/current_account/current_account_cubit.dart';
import 'package:kriptum/blocs/current_native_balance/current_native_balance_bloc.dart';
import 'package:kriptum/blocs/current_network/current_network_cubit.dart';
import 'package:kriptum/blocs/erc20_tokens/erc20_tokens_bloc.dart';
import 'package:kriptum/blocs/import_account/import_account_bloc.dart';
import 'package:kriptum/blocs/import_token/import_token_bloc.dart';
import 'package:kriptum/blocs/import_wallet/import_wallet_bloc.dart';
import 'package:kriptum/blocs/lock_wallet/lock_wallet_bloc.dart';
import 'package:kriptum/blocs/networks_list/networks_list_bloc.dart';
import 'package:kriptum/blocs/reset_wallet/reset_wallet_bloc.dart';
import 'package:kriptum/blocs/send_transaction/send_transaction_bloc.dart';
import 'package:kriptum/blocs/theme/theme_bloc.dart';
import 'package:kriptum/blocs/unlock_wallet/unlock_wallet_bloc.dart';
import 'package:kriptum/config/di/injector.dart';

Future<void> registerPresenters() async {
  injector.registerFactory<AccountListBloc>(
    () => AccountListBloc(
      injector.get(),
    ),
  );
  injector.registerFactory<AddContactBloc>(
    () => AddContactBloc(
      injector.get(),
    ),
  );
  injector.registerFactory<AddHdWalletAccountBloc>(
    () => AddHdWalletAccountBloc(
      injector.get(),
    ),
  );
  injector.registerFactory<AppBootBloc>(
    () => AppBootBloc(
      accountsRepository: injector.get(),
    ),
  );
  injector.registerFactory<BalancesBloc>(
    () => BalancesBloc(
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerFactory<ContactsBloc>(
    () => ContactsBloc(
      injector.get(),
    ),
  );
  injector.registerFactory<CreateNewWalletBloc>(
    () => CreateNewWalletBloc(
      generateAccountsPreviewUsecase: injector.get(),
      confirmAndSaveGeneratedAccountsUsecase: injector.get(),
      accountGeneratorService: injector.get(),
    ),
  );
  injector.registerFactory<CurrentNativeBalanceBloc>(
    () => CurrentNativeBalanceBloc(
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerFactory<ImportAccountBloc>(
    () => ImportAccountBloc(
      injector.get(),
    ),
  );
  injector.registerFactory<ImportWalletBloc>(
    () => ImportWalletBloc(
      injector.get(),
    ),
  );
  injector.registerFactory<LockWalletBloc>(
    () => LockWalletBloc(
      injector.get(),
    ),
  );
  injector.registerFactory<NetworksListBloc>(
    () => NetworksListBloc(
      injector.get(),
    ),
  );
  injector.registerFactory<ResetWalletBloc>(
    () => ResetWalletBloc(
      resetWalletUsecase: injector.get(),
    ),
  );
  injector.registerFactory<SendTransactionBloc>(
    () => SendTransactionBloc(
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerFactory<ThemeBloc>(
    () => ThemeBloc(
      injector.get(),
    ),
  );
  injector.registerFactory<UnlockWalletBloc>(
    () => UnlockWalletBloc(
      unlockWalletUsecase: injector.get(),
    ),
  );

  injector.registerFactory<CurrentAccountCubit>(
    () => CurrentAccountCubit(
      injector.get(),
    ),
  );

  injector.registerFactory<CurrentNetworkCubit>(
    () => CurrentNetworkCubit(
      injector.get(),
    ),
  );
  injector.registerFactory<ImportTokenBloc>(
    () => ImportTokenBloc(
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerFactory<Erc20TokensBloc>(
    () => Erc20TokensBloc(
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
}
