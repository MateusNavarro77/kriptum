import 'package:flutter_test/flutter_test.dart';
import 'package:kriptum/domain/value_objects/ethereum_amount.dart';

void main() {
  group(
    'Ethereum ammount value object tests',
    () {
      test(
        'should create Ethereum amount value object successfully',
        () {
          final oneEther = EthereumAmount.fromEther(BigInt.from(1));
          final oneFinney = EthereumAmount.fromFinney(BigInt.from(1));
          final oneGwei = EthereumAmount.fromGwei(BigInt.from(1));
          final oneWei = EthereumAmount.fromWei(BigInt.from(1));
          expect(oneEther.wei, BigInt.parse('1000000000000000000'));
          expect(oneFinney.wei, BigInt.parse('1000000000000000'));
          expect(oneGwei.wei, BigInt.parse('1000000000'));
          expect(oneWei.wei, BigInt.from(1));
        },
      );
      test('Should create Ether Amount from ether string with decimal place', () {
        final etherAmount = '1.5';
        final ethereumAmount = EthereumAmount.fromEtherDecimal(etherAmount);
        expect(ethereumAmount.wei, BigInt.parse('1500000000000000000'));
      });
      test('Should create Ether Amount from ether string without decimal place', () {
        final etherAmount = '778899';
        final ethereumAmount = EthereumAmount.fromEtherDecimal(etherAmount);
        expect(ethereumAmount.wei, BigInt.parse('778899000000000000000000'));
      });
      test('Should be converted to string', () {
        final etherAmount = '4.6753444';
        final ethereumAmount = EthereumAmount.fromEtherDecimal(etherAmount);
        expect(ethereumAmount.wei, BigInt.parse('4675344400000000000'));
        expect(ethereumAmount.toEtherString(decimals: 2), '4.67');
        expect(ethereumAmount.toEtherStringFull(), '4.675344400000000000');
      });
      test(
        'Should add',
        () {
          final amount1 = EthereumAmount.fromEtherDecimal('1.5');
          final amount2 = EthereumAmount.fromEtherDecimal('2.367');
          final sum = amount1.add(amount2);
          expect(sum.toEtherStringFull(), '3.867000000000000000');
        },
      );
      test(
        'Should sub',
        () {
          final amount1 = EthereumAmount.fromEtherDecimal('5.5');
          final amount2 = EthereumAmount.fromEtherDecimal('2.2');
          final difference = amount1.sub(amount2);
          expect(difference.toEtherStringFull(), '3.300000000000000000');
        },
      );
      test('Should multiply', () {
        final amount = EthereumAmount.fromEtherDecimal('2.5');
        final multiplied = amount.multiply(BigInt.from(3));
        expect(multiplied.toEtherStringFull(), '7.500000000000000000');
      });
      test('Should divide', () {
        final amount = EthereumAmount.fromEtherDecimal('10.0');
        final divided = amount.divide(BigInt.from(4));
        expect(divided.toEtherStringFull(), '2.500000000000000000');
      });
      test('Should compare amounts using compareTo', () {
        final amount1 = EthereumAmount.fromEtherDecimal('2.5');
        final amount2 = EthereumAmount.fromEtherDecimal('5.0');
        final amount3 = EthereumAmount.fromEtherDecimal('2.5');

        expect(amount1.compareTo(amount2), lessThan(0));
        expect(amount2.compareTo(amount1), greaterThan(0));
        expect(amount1.compareTo(amount3), equals(0));
      });
      test('Should compare amounts using < operator', () {
        final smaller = EthereumAmount.fromEtherDecimal('1.0');
        final larger = EthereumAmount.fromEtherDecimal('2.0');

        expect(smaller < larger, isTrue);
        expect(larger < smaller, isFalse);
      });
      test('Should compare amounts using <= operator', () {
        final amount1 = EthereumAmount.fromEtherDecimal('1.0');
        final amount2 = EthereumAmount.fromEtherDecimal('2.0');
        final amount3 = EthereumAmount.fromEtherDecimal('1.0');

        expect(amount1 <= amount2, isTrue);
        expect(amount1 <= amount3, isTrue);
        expect(amount2 <= amount1, isFalse);
      });
      test('Should compare amounts using > operator', () {
        final smaller = EthereumAmount.fromEtherDecimal('1.0');
        final larger = EthereumAmount.fromEtherDecimal('2.0');

        expect(larger > smaller, isTrue);
        expect(smaller > larger, isFalse);
      });
      test('Should compare amounts using >= operator', () {
        final amount1 = EthereumAmount.fromEtherDecimal('2.0');
        final amount2 = EthereumAmount.fromEtherDecimal('1.0');
        final amount3 = EthereumAmount.fromEtherDecimal('2.0');

        expect(amount1 >= amount2, isTrue);
        expect(amount1 >= amount3, isTrue);
        expect(amount2 >= amount1, isFalse);
      });
      test('Should check equality of amounts', () {
        final amount1 = EthereumAmount.fromEtherDecimal('3.5');
        final amount2 = EthereumAmount.fromEtherDecimal('3.5');
        final amount3 = EthereumAmount.fromEtherDecimal('4.0');

        expect(amount1 == amount2, isTrue);
        expect(amount1 == amount3, isFalse);
      });
      test('Should have same hashCode for equal amounts', () {
        final amount1 = EthereumAmount.fromEtherDecimal('3.5');
        final amount2 = EthereumAmount.fromEtherDecimal('3.5');

        expect(amount1.hashCode, equals(amount2.hashCode));
      });
      test('Should get ether value', () {
        final amount = EthereumAmount.fromWei(BigInt.parse('2500000000000000000'));
        expect(amount.ether, BigInt.from(2));
      });
      test('Should get finney value', () {
        final amount = EthereumAmount.fromWei(BigInt.parse('5000000000000000'));
        expect(amount.finney, BigInt.from(5));
      });
      test('Should get gwei value', () {
        final amount = EthereumAmount.fromWei(BigInt.parse('10000000000'));
        expect(amount.gwei, BigInt.from(10));
      });
      test('Should format with zero decimals', () {
        final amount = EthereumAmount.fromEtherDecimal('123.456789');
        expect(amount.toEtherString(decimals: 0), '123');
      });
      test('Should format with custom decimals', () {
        final amount = EthereumAmount.fromEtherDecimal('123.456789');
        expect(amount.toEtherString(decimals: 4), '123.4567');
        expect(amount.toEtherString(decimals: 8), '123.45678900');
      });
      test('Should throw error for invalid decimals parameter (negative)', () {
        final amount = EthereumAmount.fromEtherDecimal('1.0');
        expect(() => amount.toEtherString(decimals: -1), throwsArgumentError);
      });
      test('Should throw error for invalid decimals parameter (too large)', () {
        final amount = EthereumAmount.fromEtherDecimal('1.0');
        expect(() => amount.toEtherString(decimals: 19), throwsArgumentError);
      });
      test('Should handle zero amount', () {
        final zero = EthereumAmount.fromWei(BigInt.zero);
        expect(zero.wei, BigInt.zero);
        expect(zero.toEtherStringFull(), '0.000000000000000000');
      });
      test('Should handle very large amounts', () {
        final largeAmount = EthereumAmount.fromEther(BigInt.parse('1000000000'));
        expect(largeAmount.ether, BigInt.parse('1000000000'));
        expect(largeAmount.wei, BigInt.parse('1000000000000000000000000000'));
      });
      test('Should handle decimal strings with many decimal places', () {
        final amount = EthereumAmount.fromEtherDecimal('1.123456789012345678');
        expect(amount.toEtherStringFull(), '1.123456789012345678');
      });
      test('Should handle decimal strings with more than 18 decimal places (truncate)', () {
        final amount = EthereumAmount.fromEtherDecimal('1.123456789012345678901234');
        expect(amount.toEtherStringFull(), '1.123456789012345678');
      });
      test('Should handle decimal strings with fewer than 18 decimal places', () {
        final amount = EthereumAmount.fromEtherDecimal('1.5');
        expect(amount.toEtherStringFull(), '1.500000000000000000');
      });
      test('Should handle subtraction resulting in zero', () {
        final amount = EthereumAmount.fromEtherDecimal('5.0');
        final result = amount.sub(amount);
        expect(result.wei, BigInt.zero);
      });
      test('Should be identical to itself', () {
        final amount = EthereumAmount.fromEtherDecimal('1.0');
        expect(amount == amount, isTrue);
      });
    },
  );
}
