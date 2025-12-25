import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/blocs/balances/balances_bloc.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/usecases/get_balances_of_accounts_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBalancesOfAccountsUsecase extends Mock implements GetBalancesOfAccountsUsecase {}

class MockAccountsRepository extends Mock implements AccountsRepository {}

class MockNetworksRepository extends Mock implements NetworksRepository {}

class FakeNetwork extends Fake implements Network {}

class FakeAccount extends Fake implements Account {}

void main() {
  late BalancesBloc sut;
  late MockGetBalancesOfAccountsUsecase mockGetBalancesOfAccountsUsecase;
  late MockAccountsRepository mockAccountsRepository;
  late MockNetworksRepository mockNetworksRepository;
  late StreamController<Network> networkStreamController;
  late StreamController<List<Account>> accountsStreamController;

  final testBalances = {'0xAddress1': EthereumAmount.fromWei(BigInt.from(100))};

  setUpAll(() {
    registerFallbackValue(FakeNetwork());
    registerFallbackValue(<Account>[]);
  });

  setUp(() {
    mockGetBalancesOfAccountsUsecase = MockGetBalancesOfAccountsUsecase();
    mockAccountsRepository = MockAccountsRepository();
    mockNetworksRepository = MockNetworksRepository();
    networkStreamController = StreamController<Network>.broadcast();
    accountsStreamController = StreamController<List<Account>>.broadcast();

    when(() => mockNetworksRepository.watchCurrentNetwork()).thenAnswer((_) => networkStreamController.stream);
    when(() => mockAccountsRepository.watchAccounts()).thenAnswer((_) => accountsStreamController.stream);

    sut = BalancesBloc(
      mockGetBalancesOfAccountsUsecase,
      mockAccountsRepository,
      mockNetworksRepository,
    );
  });

  tearDown(() {
    networkStreamController.close();
    accountsStreamController.close();
    sut.close();
  });

  group('BalancesBloc', () {
    test('initial state is BalancesInitial', () {
      expect(sut.state, isA<BalancesInitial>());
    });

    group('BalancesRequested', () {
      blocTest<BalancesBloc, BalancesState>(
        'emits [BalancesLoading, BalancesLoaded] on success',
        build: () {
          when(() => mockGetBalancesOfAccountsUsecase.execute()).thenAnswer((_) async => testBalances);
          return sut;
        },
        act: (bloc) => bloc.add(BalancesRequested()),
        expect: () => [
          isA<BalancesLoading>(),
          isA<BalancesLoaded>().having((s) => s.balanceOf, 'balanceOf', testBalances),
        ],
        verify: (_) {
          verify(() => mockGetBalancesOfAccountsUsecase.execute()).called(1);
        },
      );

      blocTest<BalancesBloc, BalancesState>(
        'emits [BalancesLoading, BalancesError] on failure',
        build: () {
          when(() => mockGetBalancesOfAccountsUsecase.execute()).thenThrow(Exception('Failed to load'));
          return sut;
        },
        act: (bloc) => bloc.add(BalancesRequested()),
        expect: () => [
          isA<BalancesLoading>(),
          isA<BalancesError>().having((e) => e.errorMessage, 'errorMessage', 'Could not load balances'),
        ],
        verify: (_) {
          verify(() => mockGetBalancesOfAccountsUsecase.execute()).called(1);
        },
      );
    });

    group('Stream Subscriptions', () {
      test('adds BalancesRequested when network stream emits', () {
        when(() => mockGetBalancesOfAccountsUsecase.execute()).thenAnswer((_) async => testBalances);

        networkStreamController.add(FakeNetwork());

        expectLater(
          sut.stream,
          emitsInOrder([
            isA<BalancesLoading>(),
            isA<BalancesLoaded>(),
          ]),
        );
      });

      test('adds BalancesRequested when accounts stream emits', () {
        when(() => mockGetBalancesOfAccountsUsecase.execute()).thenAnswer((_) async => testBalances);

        accountsStreamController.add([FakeAccount()]);

        expectLater(
          sut.stream,
          emitsInOrder([
            isA<BalancesLoading>(),
            isA<BalancesLoaded>(),
          ]),
        );
      });
    });
  });
}
