import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/models/account.dart';
import 'package:kriptum/domain/models/erc20_token.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/erc20_token_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/usecases/get_erc20_balances_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';

part 'erc20_tokens_event.dart';
part 'erc20_tokens_state.dart';

class Erc20TokensBloc extends Bloc<Erc20TokensEvent, Erc20TokensState> {
  final Erc20TokenRepository _erc20tokenRepository;
  final NetworksRepository _networksRepository;
  final AccountsRepository _accountsRepository;
  final GetErc20BalancesUsecase _getErc20BalancesUsecase;
  late final StreamSubscription<Network>? _currentNetworkSubscription;
  late final StreamSubscription<Account?>? _currentAccountSubscription;
  Erc20TokensBloc(
    this._erc20tokenRepository,
    this._networksRepository,
    this._getErc20BalancesUsecase,
    this._accountsRepository,
  ) : super(Erc20TokensState.initial()) {
    _currentAccountSubscription = _accountsRepository.currentAccountStream().listen(
      (event) {
        add(Erc20TokensLoadRequested());
      },
    );
    _currentNetworkSubscription = _networksRepository.watchCurrentNetwork().listen(
      (event) {
        add(Erc20TokensLoadRequested());
      },
    );
    on<Erc20TokensLoadRequested>(_handleErc20TokensLoadRequested);
  }

  Future<void> _handleErc20TokensLoadRequested(Erc20TokensLoadRequested event, Emitter<Erc20TokensState> emit) async {
    try {
      emit(state.copyWith(status: Erc20TokensStatus.loading));
      final network = await _networksRepository.getCurrentNetwork();
      final tokens = await _erc20tokenRepository.getAllImportedTokensOfNetwork(network.id!);
      final result = await _getErc20BalancesUsecase.execute();
      final tokensWithBalances = tokens.map(
        (e) {
          return Erc20TokenWithBalance(
            balance: result.balanceOf[e.address] ?? EthereumAmount.fromWei(BigInt.zero),
            token: e,
          );
        },
      ).toList();
      emit(
        state.copyWith(
          status: Erc20TokensStatus.loaded,
          tokens: tokensWithBalances,
        ),
      );
    } on DomainException catch (e) {
      emit(state.copyWith(status: Erc20TokensStatus.error, errorMessage: e.getReason(), tokens: []));
    } catch (e) {
      emit(state.copyWith(
        status: Erc20TokensStatus.error,
        tokens: [],
        errorMessage: 'Error loading tokens',
      ));
    }
  }

  @override
  Future<void> close() {
    _currentNetworkSubscription?.cancel();
    _currentAccountSubscription?.cancel();
    return super.close();
  }
}
