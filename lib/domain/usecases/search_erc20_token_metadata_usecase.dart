import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/services/erc20_token_service.dart';
import 'package:kriptum/domain/value_objects/ethereum_address/ethereum_address.dart';

class SearchErc20TokenMetadataUsecase {
  final Erc20TokenService _erc20tokenService;
  final NetworksRepository _networksRepository;

  SearchErc20TokenMetadataUsecase(this._erc20tokenService, this._networksRepository);
  Future<SearchErc20TokenMetadataOutput> execute(SearchErc20TokenMetadataInput input) async {
    final ethAddressResult = EthereumAddress.create(input.contractAddress);
    if (ethAddressResult.isFailure) {
      throw DomainException(ethAddressResult.failure!);
    }
    final currentNetwork = await _networksRepository.getCurrentNetwork();
    final result = await Future.wait([
      _erc20tokenService.getName(
        address: ethAddressResult.value!.value,
        rpcUrl: currentNetwork.rpcUrl,
      ),
      _erc20tokenService.getSymbol(
        address: ethAddressResult.value!.value,
        rpcUrl: currentNetwork.rpcUrl,
      ),
      _erc20tokenService.getDecimals(
        address: ethAddressResult.value!.value,
        rpcUrl: currentNetwork.rpcUrl,
      ),
    ]);
    final name = result[0] as String?;
    final symbol = result[1] as String?;
    final decimals = result[2] as int?;

    return SearchErc20TokenMetadataOutput(
      name: name,
      decimals: decimals,
      symbol: symbol,
    );
  }
}

class SearchErc20TokenMetadataInput {
  final String contractAddress;

  SearchErc20TokenMetadataInput({required this.contractAddress});
}

class SearchErc20TokenMetadataOutput {
  final String? name;
  final int? decimals;
  final String? symbol;

  SearchErc20TokenMetadataOutput({required this.name, required this.decimals, required this.symbol});
}
