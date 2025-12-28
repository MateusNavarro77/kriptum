import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/blocs/send_transaction/send_transaction_bloc.dart';
import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/services/services.dart';
import 'package:kriptum/domain/usecases/get_native_balance_of_connected_account_usecase.dart';
import 'package:kriptum/domain/usecases/send_transaction_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/shared/utils/convert_string_eth_to_wei.dart';
import 'package:mocktail/mocktail.dart';

class MockAccountsRepository extends Mock implements AccountsRepository {}

class MockGetNativeBalanceOfConnectedAccountUsecase extends Mock implements GetNativeBalanceOfConnectedAccountUsecase {}

class MockSendTransactionUsecase extends Mock implements SendTransactionUsecase {}

class FakeSendTransactionUsecaseParams extends Fake implements SendTransactionUsecaseParams {}

class MockGasPriceService extends Mock implements GasPriceService {}

class MockNetworksRepository extends Mock implements NetworksRepository {}

void main() {
  late SendTransactionBloc sendTransactionBloc;
  late MockAccountsRepository mockAccountsRepository;
  late MockGetNativeBalanceOfConnectedAccountUsecase mockGetNativeBalanceOfConnectedAccountUsecase;
  late MockSendTransactionUsecase mockSendTransactionUsecase;
  late MockGasPriceService mockGasPriceService;
  late MockNetworksRepository mockNetworksRepository;
  final testAccount = Account(
    accountIndex: 0,
    address: '0xUserAddress',
    encryptedJsonWallet: 'json',
  );
  final testNetwork = Network(
    id: 1,
    name: 'Mainnet',
    rpcUrl: 'http://main.net',
    ticker: 'ETH',
    currencyDecimals: 18,
    blockExplorerUrl: 'https://etherscan.io',
  );

  setUpAll(() {
    registerFallbackValue(FakeSendTransactionUsecaseParams());
  });

  setUp(() {
    mockAccountsRepository = MockAccountsRepository();
    mockGetNativeBalanceOfConnectedAccountUsecase = MockGetNativeBalanceOfConnectedAccountUsecase();
    mockSendTransactionUsecase = MockSendTransactionUsecase();
    mockGasPriceService = MockGasPriceService();
    mockNetworksRepository = MockNetworksRepository();
    sendTransactionBloc = SendTransactionBloc(
      mockAccountsRepository,
      mockGetNativeBalanceOfConnectedAccountUsecase,
      mockSendTransactionUsecase,
      mockGasPriceService,
      mockNetworksRepository,
    );
  });

  tearDown(() {
    sendTransactionBloc.close();
  });

  group('SendTransactionBloc', () {
    test('initial state is correct', () {
      expect(sendTransactionBloc.state.status, SendTransactionState.initial().status);
    });

    group('ToAddressChanged', () {
      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits state with toAddressEqualsCurrentAccount true when addresses are the same',
        build: () {
          when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => testAccount);
          return sendTransactionBloc;
        },
        act: (bloc) => bloc.add(ToAddressChanged(toAddress: testAccount.address)),
        expect: () => [
          isA<SendTransactionState>()
              .having((s) => s.toAddressEqualsCurrentAccount, 'toAddressEqualsCurrentAccount', true),
        ],
      );

      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits state with toAddressEqualsCurrentAccount false when addresses are different',
        build: () {
          when(() => mockAccountsRepository.getCurrentAccount()).thenAnswer((_) async => testAccount);
          return sendTransactionBloc;
        },
        act: (bloc) => bloc.add(ToAddressChanged(toAddress: '0xDifferentAddress')),
        expect: () => [
          isA<SendTransactionState>()
              .having((s) => s.toAddressEqualsCurrentAccount, 'toAddressEqualsCurrentAccount', false),
        ],
      );
    });

    group('Navigation Events', () {
      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits [selectAmount] on AdvanceToAmountSelection',
        build: () => sendTransactionBloc,
        act: (bloc) => bloc.add(AdvanceToAmountSelection(toAddress: '0xSomeAddress')),
        expect: () => [
          isA<SendTransactionState>()
              .having((s) => s.sendTransactionStepStatus, 'stepStatus', SendTransactionStepStatus.selectAmount)
              .having((s) => s.toAddress, 'toAddress', '0xSomeAddress'),
        ],
      );

      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits [chooseRecpient] on ReturnToRecipientSelection',
        build: () => sendTransactionBloc,
        act: (bloc) => bloc.add(ReturnToRecipientSelection()),
        expect: () => [
          isA<SendTransactionState>()
              .having((s) => s.sendTransactionStepStatus, 'stepStatus', SendTransactionStepStatus.chooseRecpient),
        ],
      );

      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits [selectAmount] on ReturnToAmountSelection',
        build: () => sendTransactionBloc,
        act: (bloc) => bloc.add(ReturnToAmountSelection()),
        expect: () => [
          isA<SendTransactionState>()
              .having((s) => s.sendTransactionStepStatus, 'stepStatus', SendTransactionStepStatus.selectAmount),
        ],
      );
    });

    group('AdvanceToConfirmation', () {
      const amountToSend = '0.5';

      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits [loading, success] when balance is sufficient',
        build: () {
          final userBalance = EthereumAmount.fromWei(BigInt.parse('1000000000000000000')); // 1 ETH
          when(() => mockGetNativeBalanceOfConnectedAccountUsecase.execute()).thenAnswer((_) async => userBalance);
          when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
          when(() => mockGasPriceService.subscribeToGasPriceUpdates(rpcUrl: testNetwork.rpcUrl))
              .thenAnswer((_) => Stream.value(BigInt.from(20000000000)));
          return sendTransactionBloc;
        },
        act: (bloc) => bloc.add(AdvanceToConfirmation(amount: amountToSend)),
        skip: 1, // Skip the first loading state that happens during _subscribeToGasPriceUpdates
        expect: () => [
          predicate<SendTransactionState>((state) {
            return state.amountValidationStatus == AmountValidationStatus.validationSuccess &&
                state.sendTransactionStepStatus == SendTransactionStepStatus.toBeConfirmed &&
                state.amount == convertStringEthToWei(amountToSend);
          }),
          // Gas price update from the stream
          isA<SendTransactionState>().having((s) => s.gasPrice, 'gasPrice', isNotNull),
        ],
      );

      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits [loading, error] when balance is insufficient',
        build: () {
          final userBalance = EthereumAmount.fromWei(BigInt.from(1000)); // 1000 wei
          when(() => mockGetNativeBalanceOfConnectedAccountUsecase.execute()).thenAnswer((_) async => userBalance);
          when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
          when(() => mockGasPriceService.subscribeToGasPriceUpdates(rpcUrl: testNetwork.rpcUrl))
              .thenAnswer((_) => Stream.value(BigInt.from(20000000000)));
          return sendTransactionBloc;
        },
        act: (bloc) => bloc.add(AdvanceToConfirmation(amount: '0.5')), // 0.5 ETH
        skip: 1, // Skip the first loading state that happens during _subscribeToGasPriceUpdates
        expect: () => [
          isA<SendTransactionState>()
              .having((s) => s.amountValidationStatus, 'validationStatus', AmountValidationStatus.validationError)
              .having((s) => s.errorMessage, 'errorMessage', 'Not enough balance'),
          // Gas price update from the stream (still happens even after error)
          isA<SendTransactionState>().having((s) => s.gasPrice, 'gasPrice', isNotNull),
        ],
      );

      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits [loading, error] when usecase throws',
        build: () {
          when(() => mockGetNativeBalanceOfConnectedAccountUsecase.execute()).thenThrow(Exception('Usecase failed'));
          when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
          when(() => mockGasPriceService.subscribeToGasPriceUpdates(rpcUrl: testNetwork.rpcUrl))
              .thenAnswer((_) => Stream.value(BigInt.from(20000000000)));
          return sendTransactionBloc;
        },
        act: (bloc) => bloc.add(AdvanceToConfirmation(amount: amountToSend)),
        skip: 1, // Skip the first loading state that happens during _subscribeToGasPriceUpdates
        expect: () => [
          isA<SendTransactionState>()
              .having((s) => s.amountValidationStatus, 'validationStatus', AmountValidationStatus.validationError)
              .having((s) => s.errorMessage, 'errorMessage', 'Unknown error'),
          // Gas price update from the stream (still happens even after error)
          isA<SendTransactionState>().having((s) => s.gasPrice, 'gasPrice', isNotNull),
        ],
      );
    });

    group('SendTransactionRequest', () {
      final transactionOutput =
          TransactionOutput(transactionHash: '0xTxHash', transactionUrlInBlockExplorer: 'http://explorer.com/0xTxHash');

      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits [loading, success] on successful transaction',
        build: () {
          when(() => mockSendTransactionUsecase.execute(any())).thenAnswer((_) async => transactionOutput);
          return sendTransactionBloc;
        },
        seed: () => SendTransactionState.initial().copyWith(toAddress: '0xReceiver', amount: BigInt.from(100)),
        act: (bloc) => bloc.add(SendTransactionRequest()),
        expect: () => [
          isA<SendTransactionState>().having((s) => s.status, 'status', SendTransactionStatus.confirmationLoading),
          isA<SendTransactionState>()
              .having((s) => s.status, 'status', SendTransactionStatus.confirmationSuccess)
              .having((s) => s.txHash, 'txHash', transactionOutput.transactionHash)
              .having(
                  (s) => s.followOnBlockExplorerUrl, 'explorerUrl', transactionOutput.transactionUrlInBlockExplorer),
        ],
      );

      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits [loading, error] on DomainException',
        build: () {
          when(() => mockSendTransactionUsecase.execute(any())).thenThrow(DomainException('User rejected'));
          return sendTransactionBloc;
        },
        seed: () => SendTransactionState.initial().copyWith(toAddress: '0xReceiver', amount: BigInt.from(100)),
        act: (bloc) => bloc.add(SendTransactionRequest()),
        expect: () => [
          isA<SendTransactionState>().having((s) => s.status, 'status', SendTransactionStatus.confirmationLoading),
          isA<SendTransactionState>()
              .having((s) => s.status, 'status', SendTransactionStatus.confirmationError)
              .having((s) => s.errorMessage, 'errorMessage', 'User rejected'),
        ],
      );

      blocTest<SendTransactionBloc, SendTransactionState>(
        'emits [loading, error] on generic Exception',
        build: () {
          when(() => mockSendTransactionUsecase.execute(any())).thenThrow(Exception('Network error'));
          return sendTransactionBloc;
        },
        seed: () => SendTransactionState.initial().copyWith(toAddress: '0xReceiver', amount: BigInt.from(100)),
        act: (bloc) => bloc.add(SendTransactionRequest()),
        expect: () => [
          isA<SendTransactionState>().having((s) => s.status, 'status', SendTransactionStatus.confirmationLoading),
          isA<SendTransactionState>()
              .having((s) => s.status, 'status', SendTransactionStatus.confirmationError)
              .having((s) => s.errorMessage, 'errorMessage', 'Unknown Error'),
        ],
      );
    });
  });
}
