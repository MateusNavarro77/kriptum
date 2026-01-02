import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/exceptions/invalid_current_account_state_exception.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/password_repository.dart';
import 'package:kriptum/domain/services/account_decryption_with_password_service.dart';

class UnlockWalletUsecase {
  final AccountsRepository _accountsRepository;
  final AccountDecryptionWithPasswordService _accountDecryptionWithPasswordService;
  final PasswordRepository _passwordRepository;
  UnlockWalletUsecase(
      {required AccountsRepository accountsRepository,
      required AccountDecryptionWithPasswordService accountDecryptionWithPasswordService,
      required PasswordRepository passwordRepository})
      : _accountsRepository = accountsRepository,
        _accountDecryptionWithPasswordService = accountDecryptionWithPasswordService,
        _passwordRepository = passwordRepository;
  Future<void> execute(String password) async {
    final account = await _accountsRepository.getCurrentAccount();
    if (account == null) {
      throw InvalidCurrentAccountStateException('No current account found');
    }
    final gotPasswordRight = await _accountDecryptionWithPasswordService.isPasswordCorrect(
      AccountDecryptionWithPasswordParams(
        password: password,
        encryptedAccount: account.encryptedJsonWallet,
      ),
    );
    if (!gotPasswordRight) {
      throw WrongPasswordException('Wrong password');
    }
    _passwordRepository.setPassword(password);
  }
}

class WrongPasswordException extends DomainException {
  WrongPasswordException(super.message);
}
