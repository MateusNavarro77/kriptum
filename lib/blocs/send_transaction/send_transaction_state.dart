// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'send_transaction_bloc.dart';

enum SendTransactionStepStatus {
  chooseRecpient,
  selectAmount,
  toBeConfirmed,
}

enum SendTransactionStatus { confirmationIdle, confirmationLoading, confirmationSuccess, confirmationError }

enum AmountValidationStatus { validationIdle, validationLoading, validationSuccess, validationError }

class SendTransactionState {
  final SendTransactionStepStatus sendTransactionStepStatus;
  final SendTransactionStatus status;
  final AmountValidationStatus amountValidationStatus;
  final BigInt? gasPrice;
  final BigInt? amountWithGas;
  final BigInt? gasFee;
  final DateTime? confirmationTime;
  final String? toAddress;
  final BigInt? amount;
  final String? txHash;
  final String? followOnBlockExplorerUrl;
  final String errorMessage;
  final bool toAddressEqualsCurrentAccount;

  SendTransactionState({
    required this.sendTransactionStepStatus,
    required this.toAddress,
    required this.amount,
    required this.txHash,
    required this.followOnBlockExplorerUrl,
    required this.errorMessage,
    required this.toAddressEqualsCurrentAccount,
    required this.status,
    required this.amountValidationStatus,
    required this.confirmationTime,
    required this.gasPrice,
    required this.amountWithGas,
    required this.gasFee,
  });

  factory SendTransactionState.initial() {
    return SendTransactionState(
      gasPrice: null,
      amountWithGas: null,
      confirmationTime: null,
      amountValidationStatus: AmountValidationStatus.validationIdle,
      sendTransactionStepStatus: SendTransactionStepStatus.chooseRecpient,
      toAddress: null,
      amount: null,
      txHash: null,
      followOnBlockExplorerUrl: null,
      errorMessage: '',
      toAddressEqualsCurrentAccount: false,
      status: SendTransactionStatus.confirmationIdle,
      gasFee: null,
    );
  }
  SendTransactionState copyWith({
    SendTransactionStepStatus? sendTransactionStepStatus,
    String? toAddress,
    BigInt? amount,
    String? txHash,
    String? followOnBlockExplorerUrl,
    String? errorMessage,
    bool? toAddressEqualsCurrentAccount,
    SendTransactionStatus? status,
    AmountValidationStatus? amountValidationStatus,
    DateTime? confirmationTime,
    BigInt? gasPrice,
    BigInt? amountWithGas,
    BigInt? gasFee,
  }) {
    return SendTransactionState(
      confirmationTime: confirmationTime ?? this.confirmationTime,
      sendTransactionStepStatus: sendTransactionStepStatus ?? this.sendTransactionStepStatus,
      toAddress: toAddress ?? this.toAddress,
      amount: amount ?? this.amount,
      txHash: txHash ?? this.txHash,
      followOnBlockExplorerUrl: followOnBlockExplorerUrl ?? this.followOnBlockExplorerUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      toAddressEqualsCurrentAccount: toAddressEqualsCurrentAccount ?? this.toAddressEqualsCurrentAccount,
      status: status ?? this.status,
      amountValidationStatus: amountValidationStatus ?? this.amountValidationStatus,
      gasPrice: gasPrice ?? this.gasPrice,
      amountWithGas: amountWithGas ?? this.amountWithGas,
      gasFee: gasFee ?? this.gasFee,
    );
  }
}
