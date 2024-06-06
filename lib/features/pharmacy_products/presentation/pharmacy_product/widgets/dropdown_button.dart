import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class DropDownProductButton extends StatelessWidget {
  const DropDownProductButton({
    super.key, required this.hintText,this.value, required this.onChanged, required this.optionList,
  });
  final String hintText;
   final String? value;
  final void Function(String?) onChanged;
  final List<String> optionList;
  @override
  Widget build(BuildContext context) {
  
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: BColors.darkblue,
          child: DropdownButton(
            iconSize: 32,
              value:(value != null)? value: null,
              hint: Padding(
              padding: const EdgeInsets.all(12.0),
                child: Text(
                  hintText,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: BColors.white),
                ),
              ),
              iconEnabledColor: BColors.white,
              dropdownColor: BColors.darkgrey,
              style: Theme.of(context).textTheme.labelLarge,
              underline: const SizedBox(),
              alignment: Alignment.centerLeft,
              borderRadius: BorderRadius.circular(12),
              items: optionList.map((option) {
                return DropdownMenuItem(
                    alignment: Alignment.centerLeft,
                    value: option,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(option,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: BColors.white)),
                    ));
              }).toList(),
              onChanged: onChanged)
        ),
      );
    }
  }
