import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/value_objects/token_symbol.dart';

void main() {
  group(
    'TokenSymbol value object tests',
    () {
      test(
        'should create TokenSymbol value object successfully',
        () {
          final result = TokenSymbol.create('ETH');
          expect(result.isSuccess, true);
          expect(result.value?.value, 'ETH');
        },
      );
      test(
        'should sanitize whitespace when creating TokenSymbol',
        () {
          final result = TokenSymbol.create('  BTC  ');
          expect(result.isSuccess, true);
          expect(result.value?.value, 'BTC');
        },
      );
      test(
        'should fail to create TokenSymbol value object when empty',
        () {
          final result = TokenSymbol.create('');
          expect(result.isFailure, true);
          expect(result.failure, 'Token symbol cannot be empty');
        },
      );
      test(
        'should fail to create TokenSymbol value object when only whitespace',
        () {
          final result = TokenSymbol.create('   ');
          expect(result.isFailure, true);
          expect(result.failure, 'Token symbol cannot be empty');
        },
      );
      test(
        'should fail to create TokenSymbol value object when too long',
        () {
          final longSymbol = 'A' * 11; // 11 characters
          final result = TokenSymbol.create(longSymbol);
          expect(result.isFailure, true);
          expect(result.failure, 'Symbol must be lower or equal to 10 chars');
        },
      );
      test(
        'should create TokenSymbol with exactly 10 characters',
        () {
          final maxLengthSymbol = 'A' * 10; // 10 characters
          final result = TokenSymbol.create(maxLengthSymbol);
          expect(result.isSuccess, true);
          expect(result.value?.value, maxLengthSymbol);
        },
      );
      test(
        'should compare two TokenSymbol instances for equality',
        () {
          final result1 = TokenSymbol.create('ETH');
          final result2 = TokenSymbol.create('ETH');
          expect(result1.value, equals(result2.value));
        },
      );
      test(
        'should have same hashCode for equal TokenSymbol instances',
        () {
          final result1 = TokenSymbol.create('ETH');
          final result2 = TokenSymbol.create('ETH');
          expect(result1.value?.hashCode, equals(result2.value?.hashCode));
        },
      );
      test(
        'should not be equal for different token symbols',
        () {
          final result1 = TokenSymbol.create('ETH');
          final result2 = TokenSymbol.create('BTC');
          expect(result1.value, isNot(equals(result2.value)));
        },
      );
    },
  );
}
