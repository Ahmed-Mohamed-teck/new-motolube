class CharListProvider {
  static final List<String> arabicChars = [
    'أ',
    'ب',
    'ح',
    'د',
    'ر',
    'س',
    'ص',
    'ط',
    'ع',
    'ق',
    'ك',
    'ل',
    'م',
    'ن',
    'ه',
    'و',
    'ي'
  ];

  static final List<String> englishChars = [
    'A',
    'B',
    'J',
    'D',
    'R',
    'S',
    'X',
    'T',
    'E',
    'G',
    'K',
    'L',
    'Z',
    'N',
    'H',
    'U',
    'V'
  ];

  static final List<String> numbers = [
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

  static final List<String> arabicNumbers = [
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];

  static List<String> getPlateChars(String language) {
    switch (language.toLowerCase()) {
      case 'ar':
        return arabicChars;
      case 'en':
        return englishChars;
      default:
        throw ArgumentError("Invalid language. Use 'arabic' or 'english'.");
    }
  }

  static List<String> getPlateNumbers(String language) {
    switch (language.toLowerCase()) {
      case 'ar':
        return arabicNumbers;
      case 'en':
        return numbers;
      default:
        throw ArgumentError("Invalid language. Use 'ar' or 'en'.");
    }
  }


}
