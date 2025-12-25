import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/usecases/add_contact_usecase.dart';
import 'package:kriptum/domain/usecases/add_hd_wallet_account_usecase.dart';
import 'package:kriptum/domain/usecases/confirm_and_save_generated_accounts_usecase.dart';
import 'package:kriptum/domain/usecases/generate_accounts_preview_usecase.dart';
import 'package:kriptum/domain/usecases/get_balances_of_accounts_usecase.dart';
import 'package:kriptum/domain/usecases/get_erc20_balances_usecase.dart';
import 'package:kriptum/domain/usecases/get_native_balance_of_connected_account_usecase.dart';
import 'package:kriptum/domain/usecases/import_account_from_private_key_usecase.dart';
import 'package:kriptum/domain/usecases/import_erc20_token_usecase.dart';
import 'package:kriptum/domain/usecases/import_wallet_usecase.dart';
import 'package:kriptum/domain/usecases/lock_wallet_usecase.dart';
import 'package:kriptum/domain/usecases/reset_wallet_usecase.dart';
import 'package:kriptum/domain/usecases/search_erc20_token_metadata_usecase.dart';
import 'package:kriptum/domain/usecases/send_transaction_usecase.dart';
import 'package:kriptum/domain/usecases/unlock_wallet_usecase.dart';

Future<void> registerUsecases() async {
  injector.registerLazySingleton<GenerateAccountsPreviewUsecase>(
    () => GenerateAccountsPreviewUsecase(accountGenerator: injector.get(), passwordRepository: injector.get()),
  );
  injector.registerLazySingleton<ConfirmAndSaveGeneratedAccountsUsecase>(
    () => ConfirmAndSaveGeneratedAccountsUsecase(
      accountsRepository: injector.get(),
      encryptionService: injector.get(),
      mnemonicRepository: injector.get(),
      passwordRepository: injector.get(),
    ),
  );
  injector.registerLazySingleton<ResetWalletUsecase>(
    () => ResetWalletUsecase(
      accountsRepository: injector.get(),
      contactsRepository: injector.get(),
      mnemonicRepository: injector.get(),
    ),
  );
  injector.registerLazySingleton<UnlockWalletUsecase>(
    () => UnlockWalletUsecase(
      accountsRepository: injector.get(),
      accountDecryptionWithPasswordService: injector.get(),
      passwordRepository: injector.get(),
    ),
  );
  injector.registerLazySingleton<GetNativeBalanceOfConnectedAccountUsecase>(
    () => GetNativeBalanceOfConnectedAccountUsecase(
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<ImportWalletUsecase>(
    () => ImportWalletUsecase(
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<AddContactUsecase>(
    () => AddContactUsecase(
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<AddHdWalletAccountUsecase>(
    () => AddHdWalletAccountUsecase(
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<LockWalletUsecase>(
    () => LockWalletUsecase(
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<SendTransactionUsecase>(
    () => SendTransactionUsecase(
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<GetBalancesOfAccountsUsecase>(
    () => GetBalancesOfAccountsUsecase(
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<ImportAccountFromPrivateKeyUsecase>(
    () => ImportAccountFromPrivateKeyUsecase(
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<SearchErc20TokenMetadataUsecase>(
    () => SearchErc20TokenMetadataUsecase(
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<ImportErc20TokenUsecase>(
    () => ImportErc20TokenUsecase(
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
  injector.registerLazySingleton<GetErc20BalancesUsecase>(
    () => GetErc20BalancesUsecase(
      injector.get(),
      injector.get(),
      injector.get(),
      injector.get(),
    ),
  );
}
