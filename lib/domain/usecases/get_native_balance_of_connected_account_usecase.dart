import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/native_balance_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';

class GetNativeBalanceOfConnectedAccountUsecase {
  final AccountsRepository _accountsRepository;
  final NativeBalanceRepository _nativeBalanceRepository;
  final NetworksRepository _networksRepository;
  GetNativeBalanceOfConnectedAccountUsecase(
    this._accountsRepository,
    this._nativeBalanceRepository,
    this._networksRepository,
  );
  Future<EthereumAmount> execute() async {
    final account = await _accountsRepository.getCurrentAccount();
    final network = await _networksRepository.getCurrentNetwork();
    return await _nativeBalanceRepository.getNativeBalanceOfAccount(
      accountAddress: account!.address,
      network: network,
    );
  }
}
