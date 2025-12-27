part of 'send_transaction_bloc.dart';

sealed class SendTransactionEvent {}

final class AdvanceToAmountSelection extends SendTransactionEvent {
  final String toAddress;

  AdvanceToAmountSelection({required this.toAddress});
}

final class ToAddressChanged extends SendTransactionEvent {
  final String toAddress;

  ToAddressChanged({required this.toAddress});
}

final class AdvanceToConfirmation extends SendTransactionEvent {
  final String amount;

  AdvanceToConfirmation({required this.amount});
}

final class ReturnToRecipientSelection extends SendTransactionEvent {}

final class ReturnToAmountSelection extends SendTransactionEvent {}

final class SendTransactionRequest extends SendTransactionEvent {}

final class _GasPriceUpdated extends SendTransactionEvent {
  final BigInt gasPrice;

  _GasPriceUpdated({required this.gasPrice});
}
