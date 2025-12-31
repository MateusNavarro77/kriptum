import 'package:kriptum/config/di/injector.dart';
import 'package:kriptum/domain/services/services.dart';
import 'package:kriptum/infra/services/services.dart';

Future<void> registerDomainServices() async {
  injector.registerLazySingleton<EncryptionService>(
    () => EncryptionServiceImpl(),
  );
  injector.registerLazySingleton<AccountGeneratorService>(
    () => AccountGeneratorServiceImpl(),
  );
  injector.registerLazySingleton<AccountDecryptionWithPasswordService>(
    () => AccountDecryptionWithPasswordServiceImpl(),
  );
  injector.registerLazySingleton<TransactionService>(
    () => TransactionServiceImpl(
      injector.get(),
    ),
  );
  injector.registerLazySingleton<Erc20TokenService>(
    () => Erc20TokenServiceImpl(
      httpClient: injector.get(),
    ),
  );
  injector.registerLazySingleton<GasPriceService>(
    () => GasServiceImpl(
      httpClient: injector.get(),
    ),
  );
}
