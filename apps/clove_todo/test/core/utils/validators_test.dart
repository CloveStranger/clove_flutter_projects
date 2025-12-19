import 'package:clove_todo/core/utils/validators.dart';
import 'package:test/test.dart';

void main() {
  group('Validators.notEmpty', () {
    test('returns null when value not empty', () {
      expect(Validators.notEmpty('ok'), isNull);
    });

    test('returns error when empty', () {
      expect(Validators.notEmpty(''), isNotNull);
    });
  });

  group('Validators.email', () {
    test('returns null for valid email', () {
      expect(Validators.email('a@b.com'), isNull);
    });

    test('returns error for invalid email', () {
      expect(Validators.email('invalid'), isNotNull);
    });
  });

  group('Validators.minLength', () {
    test('returns null when length >= min', () {
      expect(Validators.minLength('abc', 3), isNull);
    });

    test('returns error when length < min', () {
      expect(Validators.minLength('ab', 3), isNotNull);
    });
  });

  group('Validators.maxLength', () {
    test('returns null when length <= max', () {
      expect(Validators.maxLength('ab', 3), isNull);
    });

    test('returns error when length > max', () {
      expect(Validators.maxLength('abcd', 3), isNotNull);
    });
  });
}

