import 'package:intl/intl.dart';

class AppDateFormatter {
  static String formatDDMMYYY({DateTime? dateTime, String? date}) {
    DateTime? tempDate = dateTime ?? DateTime.tryParse(date ?? "");
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    if (tempDate != null) {
      final String formatted = formatter.format(tempDate);
      return formatted;
    }
    return date ?? dateTime?.toUtc().toLocal().toString() ?? "N/A";
  }

  // Dateformat: 2th,December 1994
  static String dayMonthYearText({DateTime? dateTime, String? date}) {
    DateTime? dateForm = dateTime ?? DateTime.tryParse(date ?? "");
    if (dateForm != null) {
      DateFormat formatter = DateFormat('dd MMM yyyy');
      return formatter.format(dateForm);
    }
    return date ?? dateTime?.toString() ?? "";
  }

  static String UTCTimeFormate({DateTime? dateTime, String? time}) {
    DateTime? timeformate = DateTime.tryParse(time ?? "");
    DateFormat formatter = DateFormat('hh:mm aa');
    if (timeformate != null) {
      return formatter.format(timeformate.toLocal());
    } else {
      return dateTime != null
          ? formatter.format(dateTime)
          : "N/A";
    }
  }

  static String dateTimeText({DateTime? dateTime, String? date}) {
    print(dateTime?.isUtc);
    DateTime? dateForm = dateTime ?? DateTime.tryParse(date ?? "");

    if (dateForm != null) {
      DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm aa');
      return formatter.format(dateForm.toLocal());
    }
    return date ?? dateTime?.toLocal().toString() ?? "";
  }
}
