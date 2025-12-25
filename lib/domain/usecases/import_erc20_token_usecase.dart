import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/factories/ethereum_address/ethereum_address.dart';
import 'package:kriptum/domain/models/erc20_token.dart';
import 'package:kriptum/domain/models/token_decimals.dart';
import 'package:kriptum/domain/repositories/erc20_token_repository.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/value_objects/token_name.dart';
import 'package:kriptum/domain/value_objects/token_symbol.dart';

class ImportErc20TokenUsecase {
  final NetworksRepository _networksRepository;
  final Erc20TokenRepository _erc20tokenRepository;
  final EthereumAddressFactory _ethereumAddressFactory;
  ImportErc20TokenUsecase(this._networksRepository, this._erc20tokenRepository, this._ethereumAddressFactory);

  Future<void> execute(ImportErc20TokenInput input) async {
    final ethAddressResult = _ethereumAddressFactory.create(input.contractAddress);
    if (ethAddressResult.isFailure) {
      throw DomainException(ethAddressResult.failure!);
    }
    final nameResult = TokenName.create(input.name);
    if (nameResult.isFailure) {
      throw DomainException(nameResult.failure!);
    }
    final tokenDecimalsResult = TokenDecimals.create(input.decimals);
    if (tokenDecimalsResult.isFailure) {
      throw DomainException(tokenDecimalsResult.failure!);
    }
    final symbolResult = TokenSymbol.create(input.symbol);
    if (symbolResult.isFailure) {
      throw DomainException(symbolResult.failure!);
    }
    final currentNetwork = await _networksRepository.getCurrentNetwork();
    final foundTokenWithAddress = await _erc20tokenRepository.findByAddress(ethAddressResult.value!.value);
    if (foundTokenWithAddress != null) throw DomainException('Token already imported');
    final erc20Token = Erc20Token(
      address: ethAddressResult.value!.value,
      name: nameResult.value?.value,
      symbol: symbolResult.value!.value,
      decimals: tokenDecimalsResult.value!.value,
      networkId: currentNetwork.id!,
    );
    await _erc20tokenRepository.save(erc20Token);
  }
}

class ImportErc20TokenInput {
  final String name;
  final String symbol;
  final int decimals;
  final String contractAddress;

  ImportErc20TokenInput({
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.contractAddress,
  });
}
