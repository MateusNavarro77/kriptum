import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/mnemonic_repository.dart';
import 'package:kriptum/domain/repositories/password_repository.dart';
import 'package:kriptum/domain/services/account_generator_service.dart';
import 'package:kriptum/domain/services/encryption_service.dart';
import 'package:kriptum/domain/value_objects/mnemonic.dart';

class ImportWalletUsecase {
  final AccountGeneratorService _accountGeneratorService;
  final AccountsRepository _accountsRepository;
  final PasswordRepository _passwordRepository;
  final EncryptionService _encryptionService;
  final MnemonicRepository _mnemonicRepository;
  ImportWalletUsecase(
    this._accountGeneratorService,
    this._accountsRepository,
    this._passwordRepository,
    this._encryptionService,
    this._mnemonicRepository,
  );
  Future<void> execute(ImportWalletUsecaseParams params) async {
    final mnemonicResult = Mnemonic.create(params.mnemonic);
    if (mnemonicResult.isFailure) {
      throw Exception(mnemonicResult.failure);
    }
    final validatedMnemonic = mnemonicResult.value!.value;
    final accounts = await _accountGeneratorService.generateAccounts(
      AccountsFromMnemonicParams(
        mnemonic: validatedMnemonic,
        encryptionPassword: params.encryptionPassword,
        amount: params.amount,
      ),
    );
    await _accountsRepository.saveAccounts(accounts);
    _passwordRepository.setPassword(params.encryptionPassword);
    final encryptedMnemonic = _encryptionService.encrypt(
      data: mnemonicResult.value!.value,
      password: params.encryptionPassword,
    );
    await _mnemonicRepository.storeEncryptedMnemonic(encryptedMnemonic);
  }
}

class ImportWalletUsecaseParams {
  final String mnemonic;
  final String encryptionPassword;
  final int amount;

  ImportWalletUsecaseParams({
    required this.mnemonic,
    required this.encryptionPassword,
    this.amount = 1,
  });
}
