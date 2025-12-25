import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/erc20_token.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/erc20_token_balance_repository.dart';
import 'package:kriptum/domain/repositories/erc20_token_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/usecases/get_erc20_balances_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountsRepository extends Mock implements AccountsRepository {}

class MockNetworksRepository extends Mock implements NetworksRepository {}

class MockErc20TokenRepository extends Mock implements Erc20TokenRepository {}

class MockErc20TokenBalanceRepository extends Mock implements Erc20TokenBalanceRepository {}

class FakeNetwork extends Fake implements Network {}

void main() {
  late GetErc20BalancesUsecase sut;
  late MockAccountsRepository mockAccountsRepository;
  late MockNetworksRepository mockNetworksRepository;
  late MockErc20TokenRepository mockErc20TokenRepository;
  late MockErc20TokenBalanceRepository mockErc20TokenBalanceRepository;

  final testNetwork = Network(id: 1, name: 'Testnet', rpcUrl: 'http://test.rpc', ticker: 'ETH', currencyDecimals: 18);
  final testAccount = Account(accountIndex: 0, address: '0xUserAddress', encryptedJsonWallet: 'wallet');
  final testTokens = [
    Erc20Token(address: '0xToken1', name: 'Token One', symbol: 'TKN1', decimals: 18, networkId: 1),
    Erc20Token(address: '0xToken2', name: 'Token Two', symbol: 'TKN2', decimals: 6, networkId: 1),
  ];
  final testBalances = [
    EthereumAmount.fromWei(BigInt.from(1000)),
    EthereumAmount.fromWei(BigInt.from(2000)),
  ];

  setUpAll(() {
    registerFallbackValue(FakeNetwork());
  });

  setUp(() {
    mockAccountsRepository = MockAccountsRepository();
    mockNetworksRepository = MockNetworksRepository();
    mockErc20TokenRepository = MockErc20TokenRepository();
    mockErc20TokenBalanceRepository = MockErc20TokenBalanceRepository();

    sut = GetErc20BalancesUsecase(
      mockAccountsRepository,
      mockNetworksRepository,
      mockErc20TokenRepository,
      mockErc20TokenBalanceRepository,
    );
  });

  group('GetErc20BalancesUsecase', () {
    test('should return map of balances for all imported tokens', () async {
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => testAccount);
      when(() => mockErc20TokenRepository.getAllImportedTokensOfNetwork(any())).thenAnswer((_) async => testTokens);
      when(() => mockErc20TokenBalanceRepository.getBalance(
            erc20ContractAddress: '0xToken1',
            accountAddress: testAccount.address,
            network: testNetwork,
          )).thenAnswer((_) async => testBalances[0]);
      when(() => mockErc20TokenBalanceRepository.getBalance(
            erc20ContractAddress: '0xToken2',
            accountAddress: testAccount.address,
            network: testNetwork,
          )).thenAnswer((_) async => testBalances[1]);

      final result = await sut.execute();

      expect(result.balanceOf.length, 2);
      expect(result.balanceOf['0xToken1'], testBalances[0]);
      expect(result.balanceOf['0xToken2'], testBalances[1]);
      verify(() => mockErc20TokenRepository.getAllImportedTokensOfNetwork(testNetwork.id!)).called(1);
    });

    test('should return an empty map if no tokens are imported', () async {
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => testAccount);
      when(() => mockErc20TokenRepository.getAllImportedTokensOfNetwork(any())).thenAnswer((_) async => []);

      final result = await sut.execute();

      expect(result.balanceOf, isEmpty);
      verifyNever(() => mockErc20TokenBalanceRepository.getBalance(
            erc20ContractAddress: any(named: 'erc20ContractAddress'),
            accountAddress: any(named: 'accountAddress'),
            network: any(named: 'network'),
          ));
    });

    test('should throw DomainException if no current account is found', () {
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
      when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => null);

      expect(
        () => sut.execute(),
        throwsA(isA<DomainException>().having((e) => e.getReason(), 'reason', 'Invalid Account state')),
      );
      verifyNever(() => mockErc20TokenRepository.getAllImportedTokensOfNetwork(any()));
    });
  });
}
