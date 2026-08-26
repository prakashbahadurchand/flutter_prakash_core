extension IntExt on int {
  static final List<String> arabicNumbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
  static final List<String> nepaliUnicodeNumbers = [
    '०',
    '१',
    '२',
    '३',
    '४',
    '५',
    '६',
    '७',
    '८',
    '९',
  ];

  String toND() => toNepaliDigits();

  String toNepaliDigits() {
    final arabicNumberString = toString();
    final StringBuffer nepaliUnicodeNumber = StringBuffer();

    for (int i = 0; i < arabicNumberString.length; i++) {
      final index = arabicNumbers.indexOf(arabicNumberString[i]);
      if (index != -1) {
        nepaliUnicodeNumber.write(nepaliUnicodeNumbers[index]);
      } else {
        nepaliUnicodeNumber.write(arabicNumberString[i]);
      }
    }
    return nepaliUnicodeNumber.toString();
  }
}
