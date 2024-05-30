import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/application/pharmacy_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class TimeSlotChooserWidget extends StatelessWidget {
  const TimeSlotChooserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(builder: (context, value, _) {
      return Column(
        children: [
          Material(
            elevation: 3,
             borderRadius: BorderRadius.circular(16),
            child: SizedBox(
                height: 56,
                width: double.infinity,
                child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              surfaceTintColor: Colors.white,
                              backgroundColor: Colors.white,
                              title: const Text("Add available time slot"),
                              content: SizedBox(
                                height: 160,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TimePickerSpinnerPopUp(
                                      cancelTextStyle:
                                          Theme.of(context).textTheme.labelLarge,
                                      confirmTextStyle:
                                          Theme.of(context).textTheme.labelLarge,
                                      iconSize: 24,
                                      timeFormat: 'hh:mm a',
                                      use24hFormat: false,
                                      mode: CupertinoDatePickerMode.time,
                                      onChange: (dateTime) {
                                        value.timeSlotListElement1 =
                                            DateFormat.jm().format(dateTime);
                                      },
                                    ),
                                    Text(
                                      'To',
                                      style:
                                          Theme.of(context).textTheme.labelLarge,
                                    ),
                                    TimePickerSpinnerPopUp(
                                      cancelTextStyle:
                                          Theme.of(context).textTheme.labelLarge,
                                      confirmTextStyle:
                                          Theme.of(context).textTheme.labelLarge,
                                      iconSize: 24,
                                      timeFormat: 'hh:mm a',
                                      use24hFormat: false,
                                      mode: CupertinoDatePickerMode.time,
                                      onChange: (dateTime) {
                                        value.timeSlotListElement2 =
                                            DateFormat.jm().format(dateTime);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                SizedBox(
                                  height: 48,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        value.addTimeslot();
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              BColors.buttonLightColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16))),
                                      child: Text('Add',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Colors.white,
                                              ))),
                                ),
                              ],
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    label: Text(
                      'Add',
                      style: Theme.of(context).textTheme.labelLarge,
                    ))),
          ),
          const SizedBox(
            width: 10,
          ),
          const SizedBox(
            height: 16,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.timeSlotListElementList!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            tileColor: BColors.mainlightColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: Text(
                              value.timeSlotListElementList![index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                value.removeTimeSlot(index);
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 72,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    )
                  ],
                );
              }),
        ],
      );
    });
  }
}
