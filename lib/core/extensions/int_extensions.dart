import 'package:intl/intl.dart';

extension IntExt on int {
  String currencyFormat() {
    if (this >= 1000000) {
      return '${NumberFormat('#,##0.#').format(this / 1000000)}M';
    } else if (this >= 1000) {
      return '${NumberFormat('#,##0.#').format(this / 1000)}k';
    } else {
      return NumberFormat('#,###').format(this);
    }
  }

  String? commaFormat() => NumberFormat('#,###').format(this);
}
