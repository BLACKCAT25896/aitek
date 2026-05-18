import 'package:intl/intl.dart';

String getDayNameFromDate(String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    return DateFormat('EEE').format(date);
  } catch (e) {
    return '';
  }
}
