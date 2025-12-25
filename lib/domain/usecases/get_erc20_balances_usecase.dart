import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/repositories/accounts_repository.dart';
import 'package:kriptum/domain/repositories/erc20_token_balance_repository.dart';
import 'package:kriptum/domain/repositories/erc20_token_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';

class GetErc20BalancesUsecase {
  final AccountsRepository _accountsRepository;
  final NetworksRepository _networksRepository;
  final Erc20TokenRepository _erc20tokenRepository;
  final Erc20TokenBalanceRepository _erc20tokenBalanceRepository;

  const GetErc20BalancesUsecase(
    this._accountsRepository,
    this._networksRepository,
    this._erc20tokenRepository,
    this._erc20tokenBalanceRepository,
  );

  Future<GetErc20BalancesOutput> execute() async {
    final currentNetwork = await _networksRepository.getCurrentNetwork();
    final currentAccount = await _accountsRepository.getCurrentAccount();
    if (currentAccount == null) {
      throw DomainException('Invalid Account state');
    }
    final importedTokens = await _erc20tokenRepository.getAllImportedTokensOfNetwork(currentNetwork.id!);
    final List<Future<EthereumAmount>> requests = [];

    for (var importedToken in importedTokens) {
      requests.add(
        _erc20tokenBalanceRepository.getBalance(
          erc20ContractAddress: importedToken.address,
          accountAddress: currentAccount.address,
          network: currentNetwork,
        ),
      );
    }
    final results = await Future.wait(requests);
    final Map<String, EthereumAmount> balancesMap = {};
    for (int i = 0; i < importedTokens.length; i++) {
      balancesMap[importedTokens[i].address] = results[i];
    }
    return GetErc20BalancesOutput(balanceOf: balancesMap);
  }
}

class GetErc20BalancesOutput {
  final Map<String, EthereumAmount> balanceOf;

  const GetErc20BalancesOutput({required this.balanceOf});
}
