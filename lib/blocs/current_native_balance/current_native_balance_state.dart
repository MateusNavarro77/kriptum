// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'current_native_balance_bloc.dart';

enum CurrentNativeBalanceStatus {
  initial,
  loading,
  loaded,
  error,
}

class CurrentNativeBalanceState {
  final bool isVisible;
  final EthereumAmount? accountBalance;
  final String? errorMessage;
  final CurrentNativeBalanceStatus status;
  final String ticker;

  CurrentNativeBalanceState(
      {required this.isVisible,
      required this.accountBalance,
      required this.errorMessage,
      required this.status,
      required this.ticker});
  factory CurrentNativeBalanceState.initial() {
    return CurrentNativeBalanceState(
        isVisible: false,
        accountBalance: null,
        errorMessage: null,
        status: CurrentNativeBalanceStatus.initial,
        ticker: '');
  }

  CurrentNativeBalanceState copyWith({
    bool? isVisible,
    EthereumAmount? accountBalance,
    String? errorMessage,
    CurrentNativeBalanceStatus? status,
    String? ticker,
  }) {
    return CurrentNativeBalanceState(
      isVisible: isVisible ?? this.isVisible,
      accountBalance: accountBalance ?? this.accountBalance,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      ticker: ticker ?? this.ticker,
    );
  }
}
