import 'package:intl/intl.dart';

List<String> getLastTwoYears() {
  int currentYear = DateTime.now().year;
  List<String> years = [];
  for (int i = 0; i <= 1; i++) {
    years.add((currentYear - i).toString());
  }
  return years;
}

String formatDateTime_dd_MMM_yy_HH_mm(DateTime? dt) {
  if (dt == null) return '';
  return DateFormat('dd-MMM-yy HH:mm').format(dt);
}
