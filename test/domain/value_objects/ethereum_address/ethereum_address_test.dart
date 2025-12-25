import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/value_objects/ethereum_address/ethereum_address.dart';
import 'package:kriptum/domain/value_objects/ethereum_address/ethereum_address_validator.dart';

class MockEthereumAddressValidator implements EthereumAddressValidator {
  final bool Function(String) validationLogic;

  MockEthereumAddressValidator({required this.validationLogic});

  @override
  bool validate(String address) => validationLogic(address);
}

void main() {
  group('EthereumAddress', () {
    late MockEthereumAddressValidator mockValidator;

    setUp(() {
      // Default mock validator that validates proper format
      mockValidator = MockEthereumAddressValidator(
        validationLogic: (address) {
          return RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(address);
        },
      );
      EthereumAddress.setExternalValidator(mockValidator);
    });

    tearDown(() {
      // Reset validator after each test if needed
    });

    group('create', () {
      test('should create valid Ethereum address', () {
        // Arrange
        const validAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';

        // Act
        final result = EthereumAddress.create(validAddress);

        // Assert
        expect(result.isSuccess, true);
        expect(result.value!.value, validAddress);
      });

      test('should trim whitespace from address', () {
        // Arrange
        const validAddress = '  0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1  ';

        // Act
        final result = EthereumAddress.create(validAddress);

        // Assert
        expect(result.isSuccess, true);
        expect(result.value!.value, validAddress.trim());
      });

      test('should fail when address is empty', () {
        // Arrange
        const emptyAddress = '';

        // Act
        final result = EthereumAddress.create(emptyAddress);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, 'Ethereum address cannot be empty');
      });

      test('should fail when address is only whitespace', () {
        // Arrange
        const whitespaceAddress = '   ';

        // Act
        final result = EthereumAddress.create(whitespaceAddress);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, 'Ethereum address cannot be empty');
      });

      test('should fail when address length is not 42 characters', () {
        // Arrange
        const shortAddress = '0x742d35Cc';

        // Act
        final result = EthereumAddress.create(shortAddress);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, 'Ethereum address must be 42 characters long');
      });

      test('should fail when address does not start with 0x', () {
        // Arrange
        const invalidPrefix = 'dd742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';

        // Act
        final result = EthereumAddress.create(invalidPrefix);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, 'Ethereum address must start with 0x');
      });

      test('should fail when external validator rejects address', () {
        // Arrange
        final rejectingValidator = MockEthereumAddressValidator(
          validationLogic: (_) => false,
        );
        EthereumAddress.setExternalValidator(rejectingValidator);
        const address = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';

        // Act
        final result = EthereumAddress.create(address);

        // Assert
        expect(result.isFailure, true);
        expect(result.failure, 'Invalid Ethereum address format');
      });

      test('should throw StateError when validator is not configured', () {
        // Arrange
        EthereumAddress.setExternalValidator(null);
        const address = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';

        // Act & Assert
        expect(
          () => EthereumAddress.create(address),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('value', () {
      test('should return the full address value', () {
        // Arrange
        const validAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';
        final ethereumAddress = EthereumAddress.create(validAddress).value!;

        // Act & Assert
        expect(ethereumAddress.value, validAddress);
      });
    });

    group('withoutPrefix', () {
      test('should return address without 0x prefix', () {
        // Arrange
        const validAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';
        final ethereumAddress = EthereumAddress.create(validAddress).value!;

        // Act & Assert
        expect(ethereumAddress.withoutPrefix, '742d35Cc6634C0532925a3b844Bc9e7595f0bEb1');
      });
    });

    group('equality', () {
      test('should be equal when addresses are the same', () {
        // Arrange
        const address = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';
        final ethereumAddress1 = EthereumAddress.create(address).value!;
        final ethereumAddress2 = EthereumAddress.create(address).value!;

        // Act & Assert
        expect(ethereumAddress1, ethereumAddress2);
        expect(ethereumAddress1.hashCode, ethereumAddress2.hashCode);
      });

      test('should not be equal when addresses are different', () {
        // Arrange
        const address1 = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';
        const address2 = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb2';
        final ethereumAddress1 = EthereumAddress.create(address1).value!;
        final ethereumAddress2 = EthereumAddress.create(address2).value!;

        // Act & Assert
        expect(ethereumAddress1, isNot(ethereumAddress2));
      });

      test('should be identical when same instance', () {
        // Arrange
        const address = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';
        final ethereumAddress = EthereumAddress.create(address).value!;

        // Act & Assert
        expect(ethereumAddress == ethereumAddress, true);
      });
    });

    group('setExternalValidator', () {
      test('should allow setting a new validator', () {
        // Arrange
        final strictValidator = MockEthereumAddressValidator(
          validationLogic: (_) => false,
        );
        const address = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1';

        // Act
        EthereumAddress.setExternalValidator(strictValidator);
        final result = EthereumAddress.create(address);

        // Assert
        expect(result.isFailure, true);
      });
    });
  });
}
