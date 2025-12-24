import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/value_objects/mnemonic.dart';

const sampleValidMnemonic = 'abandon ability able about above absent absorb abstract absurd abuse access accident';
const sampleInvalidMnemonicShort = 'abandon ability able about above absent absorb abstract absurd abuse access';
const sampleInvalidMnemonicChars =
    'abandon ability able about above absent absorb abstract absurd abuse access acc1dent';
void main() {
  test('Mnemonic should not be empty', () {
    final result = Mnemonic.create('');
    expect(result.isFailure, true);
    expect(result.failure, 'Mnemonic phrase cannot be empty');
  });
  test('Mnemonic should contain exactly 12 words', () {
    final result = Mnemonic.create(sampleInvalidMnemonicShort);
    expect(result.value, isNull);
    expect(result.isFailure, true);
    expect(result.failure, 'Mnemonic phrase must contain 12 words');
  });
  test('Mnemonic should only contain letters and spaces', () {
    final result = Mnemonic.create(sampleInvalidMnemonicChars);
    expect(result.value, isNull);
    expect(result.isFailure, true);
    expect(result.failure, 'Mnemonic phrase can only contain letters and spaces');
  });
  test('Valid mnemonic should be created successfully', () {
    final result = Mnemonic.create(sampleValidMnemonic);
    expect(result.isSuccess, true);
    expect(result.value?.value, sampleValidMnemonic);
  });
  test('Two Mnemonic objects with the same phrase should be equal', () {
    final result1 = Mnemonic.create(sampleValidMnemonic);
    final result2 = Mnemonic.create(sampleValidMnemonic);
    expect(result1.isSuccess, true);
    expect(result2.isSuccess, true);
    expect(result1.value, equals(result2.value));
  });
}
