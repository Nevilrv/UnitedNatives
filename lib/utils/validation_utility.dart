class ValidationUtility {
  static String alphabetValidationPattern = r"[a-zA-Z]";
  static String alphabetSpaceValidationPattern = r"[a-zA-Z ]";
  static String alphabetDigitsValidationPattern = r"[a-zA-Z0-9]";
  static String alphabetDigitsSpaceValidationPattern = r"[a-zA-Z0-9 ]";
  static String alphabetDigitsSpecialValidationPattern = r"[a-zA-Z0-9_@. ]";
  static String address = r"[a-zA-Z0-9_@.&#, ]";
  static String digitsValidationPattern = r"[0-9]";
  static String digitsDoubleValidationPattern = r"[0-9.]";
  static int kPasswordLength = 6;
}
