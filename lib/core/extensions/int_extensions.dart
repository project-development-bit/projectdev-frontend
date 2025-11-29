import 'package:intl/intl.dart';

extension IntExt on int {
  String currencyFormat() {
    return NumberFormat('#,###').format(this);
  }
}
