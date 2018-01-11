String dateTimeToReasonableString(DateTime input) {
  String timeString = input.toString();
  return timeString.substring(0, timeString.length - 7);
}