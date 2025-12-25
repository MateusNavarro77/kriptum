import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/usecases/get_native_balance_of_connected_account_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';
import 'package:kriptum/infra/persistence/user_preferences/user_preferences.dart';

part 'current_native_balance_event.dart';
part 'current_native_balance_state.dart';

class CurrentNativeBalanceBloc extends Bloc<CurrentNativeBalanceEvent, CurrentNativeBalanceState> {
  final UserPreferences _userPreferences;
  final GetNativeBalanceOfConnectedAccountUsecase _getNativeBalanceOfAccountUsecase;
  final AccountsRepository _accountsRepository;
  final NetworksRepository _networksRepository;
  late final StreamSubscription _currentAccountChangeSubscription;
  late final StreamSubscription _currentNetworkChangeSubscription;
  late final StreamSubscription _visibilitySubscription;
  //late final StreamSubscription _currentNetworkChangeSubscription;
  CurrentNativeBalanceBloc(
    this._getNativeBalanceOfAccountUsecase,
    this._userPreferences,
    this._accountsRepository,
    this._networksRepository,
  ) : super(CurrentNativeBalanceState.initial()) {
    _currentAccountChangeSubscription = _accountsRepository.currentAccountStream().listen(
      (event) {
        add(CurrentNativeBalanceRequested());
      },
    );
    _currentNetworkChangeSubscription = _networksRepository.watchCurrentNetwork().listen(
      (event) {
        add(CurrentNativeBalanceRequested());
      },
    );
    _visibilitySubscription = _userPreferences.watchNativeBalanceVisibility().listen(
      (event) {
        add(_CurrentNativeBalanceVisibilityRefreshed(isVisible: event));
      },
    );
    on<_CurrentNativeBalanceVisibilityRefreshed>((event, emit) {
      emit(
        state.copyWith(
          isVisible: event.isVisible,
        ),
      );
    });
    on<CurrentNativeBalanceVisibilityRequested>(
      (event, emit) async {
        final isVisible = await _userPreferences.isNativeBalanceVisible();
        emit(
          state.copyWith(
            isVisible: isVisible,
          ),
        );
      },
    );
    on<ToggleCurrentNativeBalanceVisibility>(
      (event, emit) async {
        emit(
          state.copyWith(
            isVisible: event.isVisible,
          ),
        );
        await _userPreferences.setNativeBalanceVisibility(event.isVisible);
      },
    );
    on<CurrentNativeBalanceRequested>((event, emit) async {
      emit(state.copyWith(status: CurrentNativeBalanceStatus.loading));
      try {
        //await Future.delayed(const Duration(seconds: 1));
        final accountBalance = await _getNativeBalanceOfAccountUsecase.execute();
        final network = await _networksRepository.getCurrentNetwork();
        emit(
          state.copyWith(
              accountBalance: accountBalance, status: CurrentNativeBalanceStatus.loaded, ticker: network.ticker),
        );
      } catch (e) {
        emit(
          state.copyWith(
            errorMessage: 'Failed to load native balance',
            status: CurrentNativeBalanceStatus.error,
          ),
        );
      }
    });
  }
  @override
  Future<void> close() async {
    await _currentAccountChangeSubscription.cancel();
    await _currentNetworkChangeSubscription.cancel();
    await _visibilitySubscription.cancel();
    return super.close();
  }
}
