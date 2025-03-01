import 'package:flutter/services.dart';

//* This file contains some helper functions used for string validation.

abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  RegexValidator({required this.regexSource});
  final String regexSource;

  @override
  bool isValid(String value) {
    try {
      // https://regex101.com/
      final RegExp regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (final match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({required this.editingValidator});
  final StringValidator editingValidator;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final bool oldValueValid = editingValidator.isValid(oldValue.text);
    final bool newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class EmailEditingRegexValidator extends RegexValidator {
  EmailEditingRegexValidator() : super(regexSource: '^(|\\S)+\$');
}

class EmailSubmitRegexValidator extends RegexValidator {
  EmailSubmitRegexValidator() : super(regexSource: '^\\S+@\\S+\\.\\S+\$');
}

class PhoneRegexValidator extends RegexValidator {
  PhoneRegexValidator() : super(regexSource: '^[0-9]{7}\$');
}

class DateRegexValidator extends RegexValidator {
  DateRegexValidator()
      : super(
            regexSource:
                '^\\d{4}\\-(0?[1-9]|1[012])\\-(0?[1-9]|[12][0-9]|3[01])\$');
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class NewStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isEmpty;
  }
}

class MinLengthStringValidator extends StringValidator {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool isValid(String value) {
    return value.length >= minLength;
  }
}
