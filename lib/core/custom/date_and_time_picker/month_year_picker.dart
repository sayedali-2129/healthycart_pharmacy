import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class MonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String titleText;
  const MonthYearPicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.titleText,
  });

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: BColors.white,
      title: Text(widget.titleText,
          style:
              Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16)),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          DropdownButton<int>(
            menuMaxHeight: 360,
            iconEnabledColor: BColors.darkblue,
            borderRadius: BorderRadius.circular(12),
            dropdownColor: BColors.white,
            focusColor: BColors.darkblue,
            alignment: Alignment.center,
            value: selectedDate.year,
            items: List.generate(
                widget.lastDate.year - widget.firstDate.year + 1, (index) {
              return DropdownMenuItem(
                value: widget.firstDate.year + index,
                child: Text((widget.firstDate.year + index).toString()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  selectedDate = DateTime(value, selectedDate.month);
                }
              });
            },
          ),
          DropdownButton<int>(
            menuMaxHeight: 360,
            iconEnabledColor: BColors.darkblue,
            borderRadius: BorderRadius.circular(8),
            dropdownColor: BColors.white,
            focusColor: BColors.darkblue,
            alignment: Alignment.center,
            value: selectedDate.month,
            items: List.generate(12, (index) {
              return DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1}'.padLeft(2, '0')),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  selectedDate = DateTime(selectedDate.year, value);
                }
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: BColors.darkblue),
            )),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, selectedDate);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: BColors.mainlightColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: Text('Ok',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}
