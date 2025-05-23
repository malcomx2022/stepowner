import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TimeProvider extends ChangeNotifier {
  final DateFormat _format = DateFormat("dd-MMM-yy, h:mm aa");

  String currentDT = DateFormat("dd-MMM-yy, h:mm aa").format(DateTime.now());

  void updateTime() async {
    currentDT = _format.format(DateTime.now());
    notifyListeners();
  }
}
