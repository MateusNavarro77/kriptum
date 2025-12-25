import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/usecases/get_balances_of_accounts_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_accounts_repository.dart';
import '../../mocks/mock_native_balance_repository.dart';
import '../../mocks/mock_networks_repository.dart';

void main() {
  late GetBalancesOfAccountsUsecase sut;
  late MockAccountsRepository mockAccountsRepository;
  late MockNativeBalanceRepository mockNativeBalanceRepository;
  late MockNetworksRepository mockNetworksRepository;

  setUp(() {
    mockAccountsRepository = MockAccountsRepository();
    mockNativeBalanceRepository = MockNativeBalanceRepository();
    mockNetworksRepository = MockNetworksRepository();

    sut = GetBalancesOfAccountsUsecase(
      mockAccountsRepository,
      mockNativeBalanceRepository,
      mockNetworksRepository,
    );
  });
  setUpAll(() {
    registerFallbackValue(
      Network(rpcUrl: '', name: '', ticker: '', currencyDecimals: 18),
    );
  });

  group('GetBalancesOfAccountsUsecase', () {
    final testNetwork = Network(
      id: 1,
      name: 'Testnet',
      rpcUrl: 'http://test.rpc',
      ticker: 'TEST',
      currencyDecimals: 18,
    );

    final testAccounts = [
      Account(accountIndex: 0, address: '0xAddress1', encryptedJsonWallet: 'wallet1'),
      Account(accountIndex: 1, address: '0xAddress2', encryptedJsonWallet: 'wallet2'),
    ];

    final testBalances = [
      EthereumAmount.fromWei(BigInt.from(1000)),
      EthereumAmount.fromWei(BigInt.from(2000)),
    ];

    test('should return a map of account balances when successful', () async {
      when(() => mockAccountsRepository.getAccounts()).thenAnswer((_) async => testAccounts);
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);

      when(() => mockNativeBalanceRepository.getNativeBalanceOfAccount(
            accountAddress: '0xAddress1',
            network: testNetwork,
            invalidateCache: any(named: 'invalidateCache'),
          )).thenAnswer((_) async => testBalances[0]);

      when(() => mockNativeBalanceRepository.getNativeBalanceOfAccount(
            accountAddress: '0xAddress2',
            network: testNetwork,
            invalidateCache: any(named: 'invalidateCache'),
          )).thenAnswer((_) async => testBalances[1]);

      final result = await sut.execute();

      expect(result.length, 2);
      expect(result['0xAddress1'], testBalances[0]);
      expect(result['0xAddress2'], testBalances[1]);

      verify(() => mockAccountsRepository.getAccounts()).called(1);
      verify(() => mockNetworksRepository.getCurrentNetwork()).called(1);
      verify(() => mockNativeBalanceRepository.getNativeBalanceOfAccount(
            accountAddress: '0xAddress1',
            network: testNetwork,
            invalidateCache: any(named: 'invalidateCache'),
          )).called(1);
      verify(() => mockNativeBalanceRepository.getNativeBalanceOfAccount(
            accountAddress: '0xAddress2',
            network: testNetwork,
            invalidateCache: any(named: 'invalidateCache'),
          )).called(1);
    });

    test('should return an empty map when there are no accounts', () async {
      when(() => mockAccountsRepository.getAccounts()).thenAnswer((_) async => []);
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);

      final result = await sut.execute();

      expect(result, isEmpty);

      verifyNever(() => mockNativeBalanceRepository.getNativeBalanceOfAccount(
            accountAddress: any(named: 'accountAddress'),
            network: any(named: 'network'),
            invalidateCache: any(named: 'invalidateCache'),
          ));
    });

    test('should propagate exception when a dependency throws', () async {
      final testException = Exception('Failed to fetch accounts');
      when(() => mockAccountsRepository.getAccounts()).thenThrow(testException);

      expect(() => sut.execute(), throwsA(testException));
    });
  });
}
