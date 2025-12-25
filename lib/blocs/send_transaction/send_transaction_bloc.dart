import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/usecases/get_native_balance_of_connected_account_usecase.dart';
import 'package:kriptum/domain/usecases/send_transaction_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/shared/utils/convert_string_eth_to_wei.dart';

part 'send_transaction_event.dart';
part 'send_transaction_state.dart';

class SendTransactionBloc extends Bloc<SendTransactionEvent, SendTransactionState> {
  final AccountsRepository _accountsRepository;
  final GetNativeBalanceOfConnectedAccountUsecase _getNativeBalanceOfAccountUsecase;
  final SendTransactionUsecase _sendTransactionUsecase;
  SendTransactionBloc(
    this._accountsRepository,
    this._getNativeBalanceOfAccountUsecase,
    this._sendTransactionUsecase,
  ) : super(SendTransactionState.initial()) {
    on<ToAddressChanged>(_onToAddressChanged);
    on<ReturnToAmountSelection>(_onReturnToAmountSelection);
    on<ReturnToRecipientSelection>(_onReturnToRecipientSelection);
    on<AdvanceToAmountSelection>(_onAdvanceToAmountSelection);
    on<AdvanceToConfirmation>(_onAdvanceToConfirmation);
    on<SendTransactionRequest>(_onSendTransactionRequest);
  }

  Future<void> _onToAddressChanged(
    ToAddressChanged event,
    Emitter<SendTransactionState> emit,
  ) async {
    final currentAccount = await _accountsRepository.getCurrentAccount();
    emit(
      state.copyWith(
        toAddressEqualsCurrentAccount: currentAccount?.address == event.toAddress,
      ),
    );
  }

  void _onReturnToAmountSelection(
    ReturnToAmountSelection event,
    Emitter<SendTransactionState> emit,
  ) {
    emit(
      state.copyWith(
        sendTransactionStepStatus: SendTransactionStepStatus.selectAmount,
      ),
    );
  }

  void _onReturnToRecipientSelection(
    ReturnToRecipientSelection event,
    Emitter<SendTransactionState> emit,
  ) {
    emit(
      state.copyWith(
        sendTransactionStepStatus: SendTransactionStepStatus.chooseRecpient,
      ),
    );
  }

  void _onAdvanceToAmountSelection(
    AdvanceToAmountSelection event,
    Emitter<SendTransactionState> emit,
  ) {
    emit(
      state.copyWith(
        sendTransactionStepStatus: SendTransactionStepStatus.selectAmount,
        toAddress: event.toAddress,
      ),
    );
  }

  Future<void> _onAdvanceToConfirmation(
    AdvanceToConfirmation event,
    Emitter<SendTransactionState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          errorMessage: '',
          amountValidationStatus: AmountValidationStatus.validationLoading,
        ),
      );

      final bigintAmount = convertStringEthToWei(event.amount);
      final amount = EthereumAmount.fromWei(bigintAmount);
      final currentBalance = await _getNativeBalanceOfAccountUsecase.execute();

      if (amount > currentBalance) {
        emit(
          state.copyWith(
            errorMessage: 'Not enough balance',
            amountValidationStatus: AmountValidationStatus.validationError,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          amount: bigintAmount,
          sendTransactionStepStatus: SendTransactionStepStatus.toBeConfirmed,
          amountValidationStatus: AmountValidationStatus.validationSuccess,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Unknown error',
          amountValidationStatus: AmountValidationStatus.validationError,
        ),
      );
    }
  }

  Future<void> _onSendTransactionRequest(SendTransactionRequest event, Emitter<SendTransactionState> emit) async {
    try {
      emit(
        state.copyWith(
          status: SendTransactionStatus.confirmationLoading,
        ),
      );
      final params = SendTransactionUsecaseParams(
        to: state.toAddress!,
        amount: state.amount!,
      );
      final output = await _sendTransactionUsecase.execute(params);
      emit(
        state.copyWith(
            status: SendTransactionStatus.confirmationSuccess,
            txHash: output.transactionHash,
            followOnBlockExplorerUrl: output.transactionUrlInBlockExplorer,
            confirmationTime: DateTime.now()),
      );
    } on DomainException catch (e) {
      emit(
        state.copyWith(
          status: SendTransactionStatus.confirmationError,
          errorMessage: e.getReason(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SendTransactionStatus.confirmationError,
          errorMessage: 'Unknown Error',
        ),
      );
    }
  }
}
