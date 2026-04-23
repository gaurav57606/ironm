class StringUtils {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String formatName(String name) {
    return name.trim().split(' ').map((e) => capitalize(e)).join(' ');
  }
}
