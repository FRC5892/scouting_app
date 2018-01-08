typedef String NumberCrunchFunc<T>(Iterable<TimeAssociatedDatum<T>> data);

class TimeAssociatedDatum<T> {
  final T datum; // definitely can be null
  final DateTime timestamp;
  TimeAssociatedDatum(this.datum, this.timestamp);

  String toString() => datum.toString();
}

abstract class NumberCrunchFuncs {
  static String average<T extends num>(Iterable<TimeAssociatedDatum<T>> data) {
    List<TimeAssociatedDatum<T>> asList = data.where((tad) => tad.datum != null).toList();
    num total = 0;
    asList.forEach((tad) => total += tad.datum);
    return (total / asList.length).toString();
  }

  static String mostRecent<T>(Iterable<TimeAssociatedDatum<T>> data) {
    TimeAssociatedDatum<T> mostRecent = new TimeAssociatedDatum(null, new DateTime.fromMillisecondsSinceEpoch(0));
    data.forEach((tad) {
      if (tad.timestamp.isAfter(mostRecent.timestamp) && tad.datum != null) mostRecent = tad;
    });
    return mostRecent.toString();
  }

  static String percentage(Iterable<TimeAssociatedDatum<bool>> data) {
    List<TimeAssociatedDatum<bool>> asList = data.where((tad) => tad.datum != null).toList();
    try {
      double ratio = asList.where((tad) => tad.datum).length / asList.length;
      return "${(ratio * 100).round()}%";
    } on UnsupportedError {
      return "No data";
    }
  }
}