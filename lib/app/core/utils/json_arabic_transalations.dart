Map<int, String> arabicNumbersMap = {
  1: "واحد",
  2: "اثنان",
  3: "ثلاثة",
  4: "أربعة",
  5: "خمسة",
  6: "ستة",
  7: "سبعة",
  8: "ثمانية",
  9: "تسعة",
  10: "عشرة",
  11: "أحد عشر",
  12: "اثنا عشر",
  13: "ثلاثة عشر",
  14: "أربعة عشر",
  15: "خمسة عشر",
  16: "ستة عشر",
  17: "سبعة عشر",
  18: "ثمانية عشر",
  19: "تسعة عشر",
  20: "عشرين",
  30: "ثلاثين",
  40: "أربعين",
  50: "خمسيِنِ ",
  60: "ستين",
  70: "سبعين",
  80: "ثمانين",
  90: "تسعين",
  100: "مائة",
  200: "مائتان",
  300: "ثلاثمائة",
  400: "أربعمائة",
  500: "خمسمائة",
  600: "ستمائة",
  700: "سبعمائة",
  800: "ثمانمائة",
  900: "تسعمائة"

  // Add more up to 1000 here as necessary
};

dynamic convertNumberToArabic(int number) {
  String orderNumber;
  try {
    if (arabicNumbersMap.containsKey(number)) {
      return arabicNumbersMap[number]!;
    }

    List<String> parts = [];

    // Handle hundreds
    if (number >= 100) {
      int hundreds = (number ~/ 100) * 100;
      parts.add(arabicNumbersMap[hundreds]!);
      number %= 100;
    }

    // Handle tens (20-90) and teens (11-19)
    if (number >= 20) {
      int tens = (number ~/ 10) * 10;
      parts.add(arabicNumbersMap[tens]!);
      number %= 10;
    } else if (number >= 10) {
      // Directly add numbers 10-19
      parts.add(arabicNumbersMap[number]!);
      number = 0;
    }

    // Handle units (1-9)
    if (number > 0) {
      parts.add(arabicNumbersMap[number]!);
    }
    // "تسعمائة وتسعمة وتسعون"
    // "اثتنان وخمسون"

    print("===========================>${parts}");
    print("===========================>${parts.reversed.toList().join("و")}");
    // Join parts with "و" if there are multiple parts
    if (parts.length == 3) {
      List<String> prefix = [];
      List<String> suffix = [];
      prefix.add(parts[2]);
      prefix.add(parts[1]);
      suffix.add(parts[0]);
      print(prefix);
      print(suffix);
      List fullStatment = prefix + suffix;

      print("===========================>fullStatment: $fullStatment");
      // print("===========================>orderNumber: $orderNumber");
      // print("===========================>orderNumber: $orderNumber");
      orderNumber = fullStatment.reversed.toList().join(" و ");
      print(orderNumber);
    } else {
      orderNumber = parts.reversed.toList().join(" و ");
      print("===========================>orderNumber: $orderNumber");
      print("===========================>orderNumber: $orderNumber");
      print("===========================>orderNumber: $orderNumber");
    }
    return orderNumber;
  } catch (e) {
    return number;
  }
}
