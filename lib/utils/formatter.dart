class Formatter {
  static String capitalize(String value) {
    return "${value[0].toUpperCase()}${value.substring(1)}";
  }

  static String dateToString(DateTime v) {
    String day =
        "${v.year.toString()}/${v.month.toString()}/${v.day.toString()}";
    String time = "${v.hour.toString()}:${v.minute.toString()}";
    return "$day\n$time";
  }
}
