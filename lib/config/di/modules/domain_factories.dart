import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/factories/ethereum_address/ethereum_address.dart';
import 'package:kriptum/infra/validators/validators.dart';

Future<void> registerDomainFactories() async {

  injector.registerLazySingleton<EthereumAddressFactory>(
    () => EthereumAddressFactory(EthereumAddressValidatorImpl()),
  );
}
