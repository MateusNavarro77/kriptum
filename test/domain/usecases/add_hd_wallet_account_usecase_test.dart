import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/services/account_generator_service.dart';
import 'package:kriptum/domain/usecases/add_hd_wallet_account_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_account_generator_service.dart';
import '../../mocks/mock_accounts_repository.dart';
import '../../mocks/mock_encryption_service.dart';
import '../../mocks/mock_mnemonic_repository.dart';
import '../../mocks/mock_password_repository.dart';

void main() {
  late AddHdWalletAccountUsecase sut;
  late MockAccountsRepository mockAccountsRepository;
  late MockEncryptionService mockEncryptionService;
  late MockAccountGeneratorService mockAccountGeneratorService;
  late MockPasswordRepository mockPasswordRepository;
  late MockMnemonicRepository mockMnemonicRepository;

  setUpAll(() {
    registerFallbackValue(SingleAccountFromMnemonicParams(
      mnemonic: 'mnemonic',
      encryptionPassword: 'password',
      hdIndex: 0,
    ));
  });

  setUp(() {
    mockAccountsRepository = MockAccountsRepository();
    mockEncryptionService = MockEncryptionService();
    mockAccountGeneratorService = MockAccountGeneratorService();
    mockPasswordRepository = MockPasswordRepository();
    mockMnemonicRepository = MockMnemonicRepository();

    sut = AddHdWalletAccountUsecase(
      mockAccountsRepository,
      mockEncryptionService,
      mockAccountGeneratorService,
      mockPasswordRepository,
      mockMnemonicRepository,
    );
  });

  group('AddHdWalletAccountUsecase', () {
    const validPassword = 'a_valid_password';
    const encryptedMnemonic = 'encrypted_mnemonic';
    const decryptedMnemonic = 'decrypted_mnemonic';
    const currentIndex = 1;
    final newAccount = Account(
      accountIndex: currentIndex,
      address: '0xNewAddress',
      encryptedJsonWallet: 'new_encrypted_wallet',
    );

    void arrangeSuccess() {
      when(() => mockPasswordRepository.getPassword()).thenReturn(validPassword);
      when(() => mockMnemonicRepository.retrieveEncryptedMnemonic()).thenAnswer((_) async => encryptedMnemonic);
      when(() => mockEncryptionService.decrypt(
            encryptedData: encryptedMnemonic,
            password: validPassword,
          )).thenReturn(decryptedMnemonic);
      when(() => mockAccountsRepository.getCurrentIndex()).thenAnswer((_) async => currentIndex);
      when(() => mockAccountGeneratorService.generateSingleAccount(any())).thenAnswer((_) async => newAccount);
      when(() => mockAccountsRepository.saveAccounts([newAccount])).thenAnswer((_) async => Future.value());
    }

    test('should generate and save a new account successfully', () async {
      arrangeSuccess();

      await sut.execute();

      verify(() => mockAccountsRepository.saveAccounts([newAccount])).called(1);
    });

    test('should throw DomainException when password validation fails', () {
      when(() => mockPasswordRepository.getPassword()).thenReturn('invalid');

      expect(
        () => sut.execute(),
        throwsA(isA<DomainException>().having(
          (e) => e.getReason(),
          'reason',
          'Password must be at least 8 characters long',
        )),
      );

      verifyNever(() => mockMnemonicRepository.retrieveEncryptedMnemonic());
      verifyNever(() => mockAccountsRepository.saveAccounts(any()));
    });

    test('should throw an exception when decryption fails', () {
      when(() => mockPasswordRepository.getPassword()).thenReturn(validPassword);
      when(() => mockMnemonicRepository.retrieveEncryptedMnemonic()).thenAnswer((_) async => encryptedMnemonic);
      when(() => mockEncryptionService.decrypt(
            encryptedData: encryptedMnemonic,
            password: validPassword,
          )).thenThrow(Exception('Decryption failed'));

      expect(() => sut.execute(), throwsA(isA<Exception>()));

      verifyNever(() => mockAccountsRepository.saveAccounts(any()));
    });
  });
}
