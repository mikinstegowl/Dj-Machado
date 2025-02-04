import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';

extension NameInitials on String {
  ///Geting Initials String for Contect Name Avatar
  String getInitials() {
    List<String> nameParts = this.split(' ');
    if (nameParts.length < 2) {
      if (nameParts.isNotEmpty && nameParts != '') {
        String firstInitial = nameParts[0][0].capitalize ?? '';
        String secondInitial = nameParts[0][1].isNotEmpty
            ? nameParts[0][1].capitalize ?? ''
            : nameParts[0][0].capitalize ?? '';
        return '$firstInitial$secondInitial';
      } else {
        return '';
      }
    }
    String firstInitial = nameParts[0][0].capitalize ?? '';
    String secondInitial = nameParts[1][0].capitalize ?? '';

    return '$firstInitial$secondInitial';
  }
}

Uint8List stringToUint8List(String input) {
  return base64.decode(input);
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Here you can define your custom phone number format logic
    // For simplicity, let's assume the format is ###-###-####

    if (newValue.text.length > 12) {
      // Prevents entering more than 10 digits
      return oldValue;
    }

    var newText = newValue.text;

    if (newValue.text.length >= 4 && !newValue.text.contains('-')) {
      // Add hyphen after 3rd digit
      newText =
          newText.substring(0, 3) + '-' + newText.substring(3, newText.length);
    }
    if (newValue.text.length >= 8 &&
        !newValue.text.substring(4).contains('-')) {
      // Add hyphen after 7th digit
      newText =
          '${newText.substring(0, 7)}-${newText.substring(7, newText.length)}';
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}


extension PhoneNumberStringExtension on String {
  /// Formats a string into a phone number format (e.g., ###-###-####)
  String toPhoneNumberFormat() {
    // Remove any non-numeric characters
    String digits = replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 10) {
      digits = digits.substring(0, 10); // Restrict to 10 digits
    }

    if (digits.length <= 3) {
      return digits; // Return as-is if fewer than 4 digits
    } else if (digits.length <= 6) {
      return '${digits.substring(0, 3)}-${digits.substring(3)}';
    } else {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    }
  }
}

extension DateTimeFormat on DateTime {
  // Extension to convert DateTime to 'DD/MM/YYYY' format
  String toFormattedDate() {
    // Use the DateFormat from the intl package to format the DateTime
    return DateFormat('MMMM dd, yyyy').format(this);
  }
}



class Debounce {
  Duration delay;
  Timer? _timer;

  Debounce(
    this.delay,
  );

  call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  dispose() {
    _timer?.cancel();
  }
}
extension StringToList on String {
  /// Converts a JSON-like string to a List<int>
  List<int> toIntList() {
    try {
      // Decode the string into a List<dynamic>
      List<dynamic> tempList = json.decode(this);

      // Map and cast to List<int>
      return tempList.map((item) => item as int).toList();
    } catch (e) {
      throw FormatException('Invalid format for converting to List<int>: $e');
    }
  }
}