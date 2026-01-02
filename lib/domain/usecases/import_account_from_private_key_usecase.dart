import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/password_repository.dart';
import 'package:kriptum/domain/services/account_generator_service.dart';

class ImportAccountFromPrivateKeyUsecase {
  final PasswordRepository _passwordRepository;
  final AccountGeneratorService _accountGeneratorService;
  final AccountsRepository _accountsRepository;

  ImportAccountFromPrivateKeyUsecase(
    this._passwordRepository,
    this._accountGeneratorService,
    this._accountsRepository,
  );
  Future<void> execute(ImportAccountFromPrivateKeyInput params) async {
    //TODO: CREATE PRIVATE KEY VALUE OBJECT
    //TODO: Validate private key
    final encryptionPassword = _passwordRepository.getPassword();
    final importedAccount = await _accountGeneratorService.generateAccountFromPrivateKey(
      encryptionPassword: encryptionPassword,
      privateKey: params.privateKey,
    );
    final accounts = await _accountsRepository.getAccounts();
    final index = accounts.indexWhere(
      (element) => element.address == importedAccount.address,
    );
    if (index != -1) {
      throw AccountAlreadyExistsException('Account already saved');
    }
    await _accountsRepository.saveAccounts([importedAccount]);
  }
}

class ImportAccountFromPrivateKeyInput {
  final String privateKey;

  ImportAccountFromPrivateKeyInput({required this.privateKey});
}

class AccountAlreadyExistsException extends DomainException {
  AccountAlreadyExistsException(super.message);
}
