import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/mnemonic_repository.dart';
import 'package:kriptum/domain/repositories/password_repository.dart';
import 'package:kriptum/domain/services/account_generator_service.dart';
import 'package:kriptum/domain/services/encryption_service.dart';
import 'package:kriptum/domain/value_objects/password.dart';

class AddHdWalletAccountUsecase {
  final AccountsRepository _accountsRepository;
  final EncryptionService _encryptionService;
  final AccountGeneratorService _accountGeneratorService;
  final PasswordRepository _passwordRepository;
  final MnemonicRepository _mnemonicRepository;
  AddHdWalletAccountUsecase(
    this._accountsRepository,
    this._encryptionService,
    this._accountGeneratorService,
    this._passwordRepository,
    this._mnemonicRepository,
  );
  Future<void> execute() async {
    final storedInMemoryPassword = _passwordRepository.getPassword();
    final passwordValidationResult = Password.create(storedInMemoryPassword);
    if (passwordValidationResult.isFailure) {
      throw DomainException(passwordValidationResult.failure!);
    }
    final encryptedMnemonic = await _mnemonicRepository.retrieveEncryptedMnemonic();
    final mnemonic = _encryptionService.decrypt(
      encryptedData: encryptedMnemonic,
      password: passwordValidationResult.value!.value,
    );
    final currentIndex = await _accountsRepository.getCurrentIndex();
    final params = SingleAccountFromMnemonicParams(
      mnemonic: mnemonic,
      encryptionPassword: passwordValidationResult.value!.value,
      hdIndex: currentIndex,
    );
    final generatedAccount = await _accountGeneratorService.generateSingleAccount(params);
    await _accountsRepository.saveAccounts([generatedAccount]);
  }
}
