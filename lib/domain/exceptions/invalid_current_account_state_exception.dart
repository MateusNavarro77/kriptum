import 'package:kriptum/domain/exceptions/domain_exception.dart';

class InvalidCurrentAccountStateException extends DomainException {
  InvalidCurrentAccountStateException(super.message);
}