import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/services/services.dart';
import 'package:kriptum/domain/usecases/send_transaction_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_accounts_repository.dart';
import '../../mocks/mock_networks_repository.dart';
import '../../mocks/mock_password_repository.dart';
import '../../mocks/mock_transaction_service.dart';

class MockGasPriceService extends Mock implements GasPriceService {}

void main() {
  late SendTransactionUsecase sut;
  late MockAccountsRepository mockAccountsRepository;
  late MockPasswordRepository mockPasswordRepository;
  late MockNetworksRepository mockNetworksRepository;
  late MockTransactionService mockTransactionService;
  late MockGasPriceService mockGasPriceService;
  setUpAll(() {
    registerFallbackValue(SendTransactionUsecaseParams(to: '', amount: BigInt.zero));

    registerFallbackValue(BigInt.zero);
  });

  setUp(() {
    mockAccountsRepository = MockAccountsRepository();
    mockPasswordRepository = MockPasswordRepository();
    mockNetworksRepository = MockNetworksRepository();
    mockTransactionService = MockTransactionService();
    mockGasPriceService = MockGasPriceService();

    sut = SendTransactionUsecase(
      mockAccountsRepository,
      mockPasswordRepository,
      mockNetworksRepository,
      mockGasPriceService,
      mockTransactionService,
    );
  });

  group('SendTransactionUsecase', () {
    final testAccount = Account(
      accountIndex: 0,
      address: '0xSenderAddress',
      encryptedJsonWallet: 'encrypted_wallet_json',
    );
    const testPassword = 'test_password';
    const testTxHash = '0x_transaction_hash';
    final testParams = SendTransactionUsecaseParams(to: '0xReceiverAddress', amount: BigInt.from(100));

    test('should return transaction output with block explorer URL when successful', () async {
      final testNetwork = Network(
        id: 1,
        name: 'Mainnet',
        rpcUrl: 'http://main.net',
        ticker: 'ETH',
        currencyDecimals: 18,
        blockExplorerUrl: 'https://etherscan.io',
      );

      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => testAccount);
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
      when(() => mockPasswordRepository.getPassword()).thenReturn(testPassword);
      when(() => mockTransactionService.sendTransaction(
          encryptedJsonAccount: testAccount.encryptedJsonWallet,
          password: testPassword,
          to: testParams.to,
          amountInWei: testParams.amount,
          rpcUrl: testNetwork.rpcUrl,
          gasPrice: any(named: 'gasPrice'),
          maxGas: any(named: 'maxGas'))).thenAnswer((_) async => testTxHash);
      when(() => mockGasPriceService.fetchGasPrice(
            rpcUrl: testNetwork.rpcUrl,
          )).thenAnswer((_) async => BigInt.from(20000000000));
      final result = await sut.execute(testParams);

      expect(result.transactionHash, testTxHash);
      expect(result.transactionUrlInBlockExplorer, 'https://etherscan.io/tx/$testTxHash');
    });

    test('should return transaction output with special block explorer URL for network 4002', () async {
      final testNetwork = Network(
        id: 4002,
        name: 'Fantom Testnet',
        rpcUrl: 'http://fantom.test',
        ticker: 'FTM',
        currencyDecimals: 18,
        blockExplorerUrl: 'https://testnet.ftmscan.com',
      );

      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => testAccount);
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
      when(() => mockPasswordRepository.getPassword()).thenReturn(testPassword);

      when(() => mockTransactionService.sendTransaction(
            encryptedJsonAccount: any(named: 'encryptedJsonAccount'),
            password: any(named: 'password'),
            to: any(named: 'to'),
            amountInWei: any(named: 'amountInWei'),
            rpcUrl: any(named: 'rpcUrl'),
            gasPrice: any(named: 'gasPrice'),
            maxGas: any(named: 'maxGas'),
          )).thenAnswer((_) async => testTxHash);
      when(() => mockGasPriceService.fetchGasPrice(
            rpcUrl: testNetwork.rpcUrl,
          )).thenAnswer((_) async => BigInt.from(20000000000));

      final result = await sut.execute(testParams);

      expect(result.transactionHash, testTxHash);
      expect(result.transactionUrlInBlockExplorer, 'https://testnet.ftmscan.com/transactions/$testTxHash');
    });

    test('should return transaction output with null block explorer URL when not available', () async {
      final testNetwork = Network(
        id: 99,
        name: 'Localhost',
        rpcUrl: 'http://localhost:8545',
        ticker: 'ETH',
        currencyDecimals: 18,
        blockExplorerUrl: null,
      );

      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => testAccount);
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
      when(() => mockPasswordRepository.getPassword()).thenReturn(testPassword);

      when(() => mockTransactionService.sendTransaction(
            encryptedJsonAccount: any(named: 'encryptedJsonAccount'),
            password: any(named: 'password'),
            to: any(named: 'to'),
            amountInWei: any(named: 'amountInWei'),
            rpcUrl: any(named: 'rpcUrl'),
            gasPrice: any(named: 'gasPrice'),
            maxGas: any(named: 'maxGas'),
          )).thenAnswer((_) async => testTxHash);
      when(() => mockGasPriceService.fetchGasPrice(
            rpcUrl: testNetwork.rpcUrl,
          )).thenAnswer((_) async => BigInt.from(20000000000));

      final result = await sut.execute(testParams);

      expect(result.transactionHash, testTxHash);
      expect(result.transactionUrlInBlockExplorer, isNull);
    });

    test('should throw DomainException when current account is null', () async {
      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => null);

      expect(
        () => sut.execute(testParams),
        throwsA(isA<DomainException>().having((e) => e.getReason(), 'reason', 'Account is null')),
      );
    });
  });
}
