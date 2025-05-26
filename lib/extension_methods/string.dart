extension Capitalize on String {
  String capitalize() {
    if (isEmpty) {
      return '';
    }
    if (length == 1) {
      return toUpperCase();
    }
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
