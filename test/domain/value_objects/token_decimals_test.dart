import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/value_objects/token_decimals.dart';

void main() {
  group(
    'TokenDecimals value object tests',
    () {
      test(
        'should create TokenDecimals value object successfully',
        () {
          final result = TokenDecimals.create(18);
          expect(result.isSuccess, true);
          expect(result.value?.value, 18);
        },
      );
      test(
        'should create TokenDecimals with zero value',
        () {
          final result = TokenDecimals.create(0);
          expect(result.isSuccess, true);
          expect(result.value?.value, 0);
        },
      );
      test(
        'should create TokenDecimals with large value',
        () {
          final result = TokenDecimals.create(255);
          expect(result.isSuccess, true);
          expect(result.value?.value, 255);
        },
      );
      test(
        'should fail to create TokenDecimals value object when negative',
        () {
          final result = TokenDecimals.create(-1);
          expect(result.isFailure, true);
          expect(result.failure, 'Cannot be negative');
        },
      );
      test(
        'should fail to create TokenDecimals with large negative value',
        () {
          final result = TokenDecimals.create(-100);
          expect(result.isFailure, true);
          expect(result.failure, 'Cannot be negative');
        },
      );
      test(
        'should compare two TokenDecimals instances for equality',
        () {
          final result1 = TokenDecimals.create(18);
          final result2 = TokenDecimals.create(18);
          expect(result1.value, equals(result2.value));
        },
      );
      test(
        'should have same hashCode for equal TokenDecimals instances',
        () {
          final result1 = TokenDecimals.create(18);
          final result2 = TokenDecimals.create(18);
          expect(result1.value?.hashCode, equals(result2.value?.hashCode));
        },
      );
      test(
        'should not be equal for different token decimals',
        () {
          final result1 = TokenDecimals.create(18);
          final result2 = TokenDecimals.create(6);
          expect(result1.value, isNot(equals(result2.value)));
        },
      );
    },
  );
}
