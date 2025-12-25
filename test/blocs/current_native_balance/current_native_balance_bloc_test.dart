import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/blocs/current_native_balance/current_native_balance_bloc.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/usecases/get_native_balance_of_connected_account_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/infra/persistence/user_preferences/user_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockUserPreferences extends Mock implements UserPreferences {}

class MockGetNativeBalanceOfConnectedAccountUsecase extends Mock implements GetNativeBalanceOfConnectedAccountUsecase {}

class MockAccountsRepository extends Mock implements AccountsRepository {}

class MockNetworksRepository extends Mock implements NetworksRepository {}

class FakeAccount extends Fake implements Account {}

class FakeNetwork extends Fake implements Network {}

void main() {
  late CurrentNativeBalanceBloc sut;
  late MockUserPreferences mockUserPreferences;
  late MockGetNativeBalanceOfConnectedAccountUsecase mockGetNativeBalanceOfAccountUsecase;
  late MockAccountsRepository mockAccountsRepository;
  late MockNetworksRepository mockNetworksRepository;
  late StreamController<Account?> accountStreamController;
  late StreamController<Network> networkStreamController;
  late StreamController<bool> visibilityStreamController;
  final testNetwork = Network(id: 1, name: 'Testnet', rpcUrl: '', ticker: 'TEST', currencyDecimals: 18);
  final testBalance = EthereumAmount.fromWei(BigInt.from(1000));

  setUpAll(() {
    registerFallbackValue(FakeAccount());
    registerFallbackValue(FakeNetwork());
  });

  setUp(() {
    mockUserPreferences = MockUserPreferences();
    mockGetNativeBalanceOfAccountUsecase = MockGetNativeBalanceOfConnectedAccountUsecase();
    mockAccountsRepository = MockAccountsRepository();
    mockNetworksRepository = MockNetworksRepository();
    accountStreamController = StreamController<Account?>.broadcast();
    networkStreamController = StreamController<Network>.broadcast();
    visibilityStreamController = StreamController<bool>.broadcast();

    when(() => mockAccountsRepository.currentAccountStream()).thenAnswer((_) => accountStreamController.stream);
    when(() => mockNetworksRepository.watchCurrentNetwork()).thenAnswer((_) => networkStreamController.stream);
    when(() => mockUserPreferences.watchNativeBalanceVisibility()).thenAnswer((_) => visibilityStreamController.stream);

    sut = CurrentNativeBalanceBloc(
      mockGetNativeBalanceOfAccountUsecase,
      mockUserPreferences,
      mockAccountsRepository,
      mockNetworksRepository,
    );
  });

  tearDown(() {
    accountStreamController.close();
    networkStreamController.close();
    sut.close();
  });

  group('CurrentNativeBalanceBloc', () {
    test('initial state is correct', () {
      expect(sut.state.status, CurrentNativeBalanceState.initial().status);
    });

    group('CurrentNativeBalanceVisibilityRequested', () {
      blocTest<CurrentNativeBalanceBloc, CurrentNativeBalanceState>(
        'emits state with isVisible true when preference is true',
        build: () {
          when(() => mockUserPreferences.isNativeBalanceVisible()).thenAnswer((_) async => true);
          return sut;
        },
        act: (bloc) => bloc.add(CurrentNativeBalanceVisibilityRequested()),
        expect: () => [
          isA<CurrentNativeBalanceState>().having((s) => s.isVisible, 'isVisible', true),
        ],
      );
    });

    group('ToggleCurrentNativeBalanceVisibility', () {
      blocTest<CurrentNativeBalanceBloc, CurrentNativeBalanceState>(
        'emits state with new visibility and saves preference',
        build: () {
          when(() => mockUserPreferences.setNativeBalanceVisibility(any())).thenAnswer((_) async {});
          return sut;
        },
        act: (bloc) => bloc.add(ToggleCurrentNativeBalanceVisibility(isVisible: false)),
        expect: () => [
          isA<CurrentNativeBalanceState>().having((s) => s.isVisible, 'isVisible', false),
        ],
        verify: (_) {
          verify(() => mockUserPreferences.setNativeBalanceVisibility(false)).called(1);
        },
      );
    });

    group('CurrentNativeBalanceRequested', () {
      blocTest<CurrentNativeBalanceBloc, CurrentNativeBalanceState>(
        'emits [loading, loaded] on successful balance fetch',
        build: () {
          when(() => mockGetNativeBalanceOfAccountUsecase.execute()).thenAnswer((_) async => testBalance);
          when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
          return sut;
        },
        act: (bloc) => bloc.add(CurrentNativeBalanceRequested()),
        expect: () => [
          isA<CurrentNativeBalanceState>().having((s) => s.status, 'status', CurrentNativeBalanceStatus.loading),
          isA<CurrentNativeBalanceState>()
              .having((s) => s.status, 'status', CurrentNativeBalanceStatus.loaded)
              .having((s) => s.accountBalance, 'accountBalance', testBalance)
              .having((s) => s.ticker, 'ticker', testNetwork.ticker),
        ],
      );

      blocTest<CurrentNativeBalanceBloc, CurrentNativeBalanceState>(
        'emits [loading, error] when balance fetch fails',
        build: () {
          when(() => mockGetNativeBalanceOfAccountUsecase.execute()).thenThrow(Exception('Failed to fetch'));
          return sut;
        },
        act: (bloc) => bloc.add(CurrentNativeBalanceRequested()),
        expect: () => [
          isA<CurrentNativeBalanceState>().having((s) => s.status, 'status', CurrentNativeBalanceStatus.loading),
          isA<CurrentNativeBalanceState>()
              .having((s) => s.status, 'status', CurrentNativeBalanceStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', 'Failed to load native balance'),
        ],
      );
    });

    group('Stream Subscriptions', () {
      test('adds CurrentNativeBalanceRequested when account stream emits', () {
        when(() => mockGetNativeBalanceOfAccountUsecase.execute()).thenAnswer((_) async => testBalance);
        when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);

        accountStreamController.add(FakeAccount());

        expectLater(
          sut.stream,
          emitsInOrder([
            isA<CurrentNativeBalanceState>().having((s) => s.status, 'status', CurrentNativeBalanceStatus.loading),
            isA<CurrentNativeBalanceState>().having((s) => s.status, 'status', CurrentNativeBalanceStatus.loaded),
          ]),
        );
      });

      test('adds CurrentNativeBalanceRequested when network stream emits', () {
        when(() => mockGetNativeBalanceOfAccountUsecase.execute()).thenAnswer((_) async => testBalance);
        when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);

        networkStreamController.add(FakeNetwork());

        expectLater(
          sut.stream,
          emitsInOrder([
            isA<CurrentNativeBalanceState>().having((s) => s.status, 'status', CurrentNativeBalanceStatus.loading),
            isA<CurrentNativeBalanceState>().having((s) => s.status, 'status', CurrentNativeBalanceStatus.loaded),
          ]),
        );
      });
    });
  });
}
