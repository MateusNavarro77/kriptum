import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/value_objects/password.dart';

void main() {
  group(
    'Password value object tests',
    () {
      test(
        'should create Password value object successfully',
        () {
          final result = Password.create('StrongPass123');
          expect(result.isSuccess, true);
          expect(result.value?.value, 'StrongPass123');
        },
      );
      test(
        'should fail to create Password value object when empty',
        () {
          final result = Password.create('');
          expect(result.isFailure, true);
          expect(result.failure, 'Password cannot be empty');
        },
      );
      test(
        'should fail to create Password value object when too short',
        () {
          final result = Password.create('short');
          expect(result.isFailure, true);
          expect(result.failure, 'Password must be at least 8 characters long');
        },
      );
      test(
        'should fail to create Password value object when too long',
        () {
          final longPassword = 'a' * 32; // 32 characters
          final result = Password.create(longPassword);
          expect(result.isFailure, true);
          expect(result.failure, 'Password too large');
        },
      );
    },
  );
}
