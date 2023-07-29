import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  // Define the format you want
  final DateFormat formatter = DateFormat('dd MMMM, y');

  // Format the date using the formatter
  String formattedDate = formatter.format(date);
  return formattedDate;
}
