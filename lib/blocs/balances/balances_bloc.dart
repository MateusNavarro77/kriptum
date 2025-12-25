import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/usecases/get_balances_of_accounts_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';

part 'balances_event.dart';
part 'balances_state.dart';

class BalancesBloc extends Bloc<BalancesEvent, BalancesState> {
  late final StreamSubscription<Network> _currentNetworkChangeSubscription;
  late final StreamSubscription<List<Account>> _accountsSubscription;
  final GetBalancesOfAccountsUsecase _getBalancesOfAccountsUsecase;
  final AccountsRepository _accountsRepository;
  final NetworksRepository _networksRepository;
  BalancesBloc(
    this._getBalancesOfAccountsUsecase,
    this._accountsRepository,
    this._networksRepository,
  ) : super(BalancesInitial()) {
    _currentNetworkChangeSubscription = _networksRepository.watchCurrentNetwork().listen(
      (_) {
        add(BalancesRequested());
      },
    );
    _accountsSubscription = _accountsRepository.watchAccounts().listen(
      (_) {
        add(BalancesRequested());
      },
    );
    on<BalancesRequested>((event, emit) async {
      try {
        emit(BalancesLoading());
        final balanceOf = await _getBalancesOfAccountsUsecase.execute();
        emit(BalancesLoaded(balanceOf: balanceOf));
      } catch (e) {
        emit(BalancesError(errorMessage: 'Could not load balances'));
      }
    });
  }

  @override
  Future<void> close() {
    _accountsSubscription.cancel();
    _currentNetworkChangeSubscription.cancel();
    return super.close();
  }
}
