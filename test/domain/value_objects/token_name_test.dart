import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/value_objects/token_name.dart';

void main() {
  group(
    'TokenName value object tests',
    () {
      test(
        'should create TokenName value object successfully',
        () {
          final result = TokenName.create('Ethereum');
          expect(result.isSuccess, true);
          expect(result.value?.value, 'Ethereum');
        },
      );
      test(
        'should sanitize whitespace when creating TokenName',
        () {
          final result = TokenName.create('  Bitcoin  ');
          expect(result.isSuccess, true);
          expect(result.value?.value, 'Bitcoin');
        },
      );
      test(
        'should fail to create TokenName value object when empty',
        () {
          final result = TokenName.create('');
          expect(result.isFailure, true);
          expect(result.failure, 'Token name cannot be empty');
        },
      );
      test(
        'should fail to create TokenName value object when only whitespace',
        () {
          final result = TokenName.create('   ');
          expect(result.isFailure, true);
          expect(result.failure, 'Token name cannot be empty');
        },
      );
      test(
        'should fail to create TokenName value object when too long',
        () {
          final longName = 'a' * 32; // 32 characters
          final result = TokenName.create(longName);
          expect(result.isFailure, true);
          expect(result.failure, 'Token name too large');
        },
      );
      test(
        'should create TokenName with exactly 31 characters',
        () {
          final maxLengthName = 'a' * 31; // 31 characters
          final result = TokenName.create(maxLengthName);
          expect(result.isSuccess, true);
          expect(result.value?.value, maxLengthName);
        },
      );
      test(
        'should compare two TokenName instances for equality',
        () {
          final result1 = TokenName.create('Ethereum');
          final result2 = TokenName.create('Ethereum');
          expect(result1.value, equals(result2.value));
        },
      );
      test(
        'should have same hashCode for equal TokenName instances',
        () {
          final result1 = TokenName.create('Ethereum');
          final result2 = TokenName.create('Ethereum');
          expect(result1.value?.hashCode, equals(result2.value?.hashCode));
        },
      );
      test(
        'should not be equal for different token names',
        () {
          final result1 = TokenName.create('Ethereum');
          final result2 = TokenName.create('Bitcoin');
          expect(result1.value, isNot(equals(result2.value)));
        },
      );
    },
  );
}
