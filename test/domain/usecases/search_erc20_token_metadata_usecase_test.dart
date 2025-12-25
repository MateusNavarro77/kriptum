import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/exceptions/domain_exception.dart';
import 'package:kriptum/domain/models/network.dart';
import 'package:kriptum/domain/repositories/networks_repository.dart';
import 'package:kriptum/domain/services/erc20_token_service.dart';
import 'package:kriptum/domain/usecases/search_erc20_token_metadata_usecase.dart';
import 'package:kriptum/domain/value_objects/ethereum_address/ethereum_address.dart';
import 'package:kriptum/domain/value_objects/ethereum_address/ethereum_address_validator.dart';
import 'package:mocktail/mocktail.dart';

class MockErc20TokenService extends Mock implements Erc20TokenService {}

class MockNetworksRepository extends Mock implements NetworksRepository {}

class MockEthereumAddressValidator implements EthereumAddressValidator {
  final bool Function(String) validationLogic;

  MockEthereumAddressValidator({required this.validationLogic});

  @override
  bool validate(String address) => validationLogic(address);
}



void main() {
  late SearchErc20TokenMetadataUsecase sut;
  late MockErc20TokenService mockErc20TokenService;
  late MockNetworksRepository mockNetworksRepository;

  final testInput = SearchErc20TokenMetadataInput(
    contractAddress: '0x1234567890123456789012345678901234567890',
  );

  final testNetwork = Network(id: 1, name: 'Testnet', rpcUrl: 'http://test.rpc', ticker: 'ETH', currencyDecimals: 18);

  setUp(() {
    mockErc20TokenService = MockErc20TokenService();
    mockNetworksRepository = MockNetworksRepository();

    // Set up the Ethereum address validator
    final mockValidator = MockEthereumAddressValidator(
      validationLogic: (address) {
        return RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(address);
      },
    );
    EthereumAddress.setExternalValidator(mockValidator);

    sut = SearchErc20TokenMetadataUsecase(
      mockErc20TokenService,
      mockNetworksRepository,
    );
  });

  group('SearchErc20TokenMetadataUsecase', () {
    test('should return token metadata on successful fetch', () async {
     
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
      when(() => mockErc20TokenService.getName(address: any(named: 'address'), rpcUrl: any(named: 'rpcUrl')))
          .thenAnswer((_) async => 'Test Token');
      when(() => mockErc20TokenService.getSymbol(address: any(named: 'address'), rpcUrl: any(named: 'rpcUrl')))
          .thenAnswer((_) async => 'TST');
      when(() => mockErc20TokenService.getDecimals(address: any(named: 'address'), rpcUrl: any(named: 'rpcUrl')))
          .thenAnswer((_) async => 18);

      final result = await sut.execute(testInput);

      expect(result.name, 'Test Token');
      expect(result.symbol, 'TST');
      expect(result.decimals, 18);

      verify(() => mockErc20TokenService.getName(address: testInput.contractAddress, rpcUrl: testNetwork.rpcUrl))
          .called(1);
      verify(() => mockErc20TokenService.getSymbol(address: testInput.contractAddress, rpcUrl: testNetwork.rpcUrl))
          .called(1);
      verify(() => mockErc20TokenService.getDecimals(address: testInput.contractAddress, rpcUrl: testNetwork.rpcUrl))
          .called(1);
    });

    test('should throw DomainException if address validation fails', () {
      final invalidInput = SearchErc20TokenMetadataInput(
        contractAddress: 'invalid_address',
      );

      expect(
        () => sut.execute(invalidInput),
        throwsA(isA<DomainException>().having((e) => e.getReason(), 'reason', 'Ethereum address must be 42 characters long')),
      );

      verifyNever(() => mockNetworksRepository.getCurrentNetwork());
      verifyNever(() => mockErc20TokenService.getName(address: any(named: 'address'), rpcUrl: any(named: 'rpcUrl')));
    });

    test('should propagate exception if token service fails', () {
      final testException = Exception('RPC Error');
      
      when(() => mockNetworksRepository.getCurrentNetwork()).thenAnswer((_) async => testNetwork);
      when(() => mockErc20TokenService.getName(address: any(named: 'address'), rpcUrl: any(named: 'rpcUrl')))
          .thenThrow(testException);
      when(() => mockErc20TokenService.getSymbol(address: any(named: 'address'), rpcUrl: any(named: 'rpcUrl')))
          .thenAnswer((_) async => 'TST');
      when(() => mockErc20TokenService.getDecimals(address: any(named: 'address'), rpcUrl: any(named: 'rpcUrl')))
          .thenAnswer((_) async => 18);

      expect(() => sut.execute(testInput), throwsA(testException));
    });
  });
}
