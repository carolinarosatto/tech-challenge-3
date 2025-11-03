import 'package:intl/intl.dart';

class FormatterUtils {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String formatAmount(double amount) {
    final brazilianCurrency = NumberFormat.simpleCurrency(
      locale: 'pt_BR',
      decimalDigits: 2,
      name: 'R\$',
    );

    return brazilianCurrency.format(amount);
  }
}
