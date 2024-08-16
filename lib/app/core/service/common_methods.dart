List<String> getLastTwoYears() {
  int currentYear = DateTime.now().year;
  List<String> years = [];
  for (int i = 1; i <= 2; i++) {
    years.add((currentYear - i).toString());
  }
  return years;
}
