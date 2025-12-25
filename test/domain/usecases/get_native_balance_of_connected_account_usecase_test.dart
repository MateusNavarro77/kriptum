import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/network.dart';

import 'package:kriptum/domain/usecases/get_native_balance_of_connected_account_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_accounts_repository.dart';
import '../../mocks/mock_native_balance_repository.dart';
import '../../mocks/mock_networks_repository.dart';

class FakeNetwork extends Fake implements Network {}

void main() {
  late GetNativeBalanceOfConnectedAccountUsecase sut;
  late MockAccountsRepository mockAccountsRepository;
  late MockNativeBalanceRepository mockNativeBalanceRepository;
  late MockNetworksRepository mockNetworksRepository;

  setUpAll(() {
    registerFallbackValue(FakeNetwork());
  });

  setUp(() {
    mockAccountsRepository = MockAccountsRepository();
    mockNativeBalanceRepository = MockNativeBalanceRepository();
    mockNetworksRepository = MockNetworksRepository();

    sut = GetNativeBalanceOfConnectedAccountUsecase(
      mockAccountsRepository,
      mockNativeBalanceRepository,
      mockNetworksRepository,
    );
  });

  group('GetNativeBalanceOfConnectedAccountUsecase', () {
    final testAccount = Account(
      accountIndex: 0,
      address: '0xTestAddress',
      encryptedJsonWallet: 'test_wallet',
    );
    final testNetwork = Network(
      id: 1,
      name: 'Testnet',
      rpcUrl: 'http://test.rpc',
      ticker: 'TEST',
      currencyDecimals: 18,
    );
    final testBalance = EthereumAmount.fromWei(BigInt.from(5000));

    test('should return the native balance of the current account', () async {
      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => testAccount);
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
      when(() => mockNativeBalanceRepository.getNativeBalanceOfAccount(
            accountAddress: testAccount.address,
            network: testNetwork,
            invalidateCache: any(named: 'invalidateCache'),
          )).thenAnswer((_) async => testBalance);

      final result = await sut.execute();

      expect(result, testBalance);

      verify(() => mockAccountsRepository.getCurrentAccount()).called(1);
      verify(() => mockNetworksRepository.getCurrentNetwork()).called(1);
      verify(() => mockNativeBalanceRepository.getNativeBalanceOfAccount(
            accountAddress: testAccount.address,
            network: testNetwork,
            invalidateCache: any(named: 'invalidateCache'),
          )).called(1);
    });

    test('should throw an error when current account is null', () async {
      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => null);
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);

      expect(() => sut.execute(), throwsA(isA<TypeError>()));

      verifyNever(() => mockNativeBalanceRepository.getNativeBalanceOfAccount(
            accountAddress: any(named: 'accountAddress'),
            network: any(named: 'network'),
            invalidateCache: any(named: 'invalidateCache'),
          ));
    });

    test('should propagate exception when a dependency throws', () async {
      final testException = Exception('Network error');
      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => testAccount);
      when(() => mockNetworksRepository.getCurrentNetwork()).thenThrow(testException);

      expect(() => sut.execute(), throwsA(testException));
    });
  });
}
