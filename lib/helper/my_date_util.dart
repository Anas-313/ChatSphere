import 'package:flutter/material.dart';

class MyDateUtil {
  // FORMATTING microsecondsSinceEpoch
  static String getFormattedTime({
    required BuildContext context,
    required String time,
  }) {
    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // GET LAST MESSAGE TIME (USED IN CHAT USER CARD)
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sentTime =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    final DateTime currentTime = DateTime.now();

    if (currentTime.day == sentTime.day &&
        currentTime.month == sentTime.month &&
        currentTime.year == sentTime.year) {
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }
    return showYear
        ? '${sentTime.day} ${_getMonth(sentTime)} ${sentTime.year}'
        : '${sentTime.day} ${_getMonth(sentTime)}';
  }

  // GET FORMATTED LAST ACTIVE TIME FOR USER IN CHAT SCREEN
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.parse(lastActive) ?? -1;

    //IF TIME IS NOT AVAILABLE THEN RETURN BELOW STATEMENT
    if (i == -1) {
      return 'Last seen not available';
    }

    DateTime time = DateTime.fromMicrosecondsSinceEpoch(i);
    DateTime currentTime = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == currentTime.day &&
        time.month == currentTime.month &&
        time.year == currentTime.year) {
      return 'Last seen at $formattedTime';
    }

    if ((currentTime.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }
    String month = _getMonth(time);
    return 'Last seen on ${time.day} $month at $formattedTime';
  }

  // GET MONTH NAME ACCORDING TO MONTH NUMBER
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Fab';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
