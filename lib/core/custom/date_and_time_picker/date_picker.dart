import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/date_and_time_picker/month_year_picker.dart';
import 'package:intl/intl.dart';

class DatePicker {
  DatePicker._();
  static final DatePicker _instance = DatePicker._();
  static DatePicker get instance => _instance;

  selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  /// This builds material date picker in Android
  Future<DateTime?> buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child ?? const SizedBox(),
        );
      },
    );
    return picked;
  }

  /// This builds cupertion date picker in iOS
  Future<DateTime?> buildCupertinoDatePicker(BuildContext context) async{
   final DateTime picked = await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {},
              minimumYear: 2015,
              maximumYear: 2100,
            ),
          );
        });
  return picked;
  }
  Future<DateTime?> showMonthYearPicker(BuildContext context, DateTime initialDate, DateTime firstDate, DateTime lastDate, String titleText) {
  return showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return MonthYearPicker(
        titleText :titleText,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    },
  );
}
  
}
