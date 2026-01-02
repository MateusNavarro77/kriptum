import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';

part 'current_account_state.dart';

class CurrentAccountCubit extends Cubit<CurrentAccountState> {
  final AccountsRepository _accountsRepository;
  late final StreamSubscription<Account?> _accountSubscription;

  CurrentAccountCubit(this._accountsRepository) : super(CurrentAccountState.initial()) {
    _accountSubscription = _accountsRepository.currentAccountStream().listen(
      (account) {
        emit(CurrentAccountState(account: account));
      },
    );
  }

  Future<void> requestCurrentAccount() async {
    try {
      final account = await _accountsRepository.getCurrentAccount();
      emit(CurrentAccountState(account: account));
    } catch (_) {
      emit(CurrentAccountState(account: null));
    }
  }

  Future<void> changeCurrentAccount(Account account) async {
    try {
      await _accountsRepository.changeCurrentAccount(account);
    } catch (_) {
      emit(CurrentAccountState(account: null));
    }
  }

  @override
  Future<void> close() async {
    await _accountSubscription.cancel();
    return super.close();
  }
}
