
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddNewRoundWidget extends StatelessWidget {

  const AddNewRoundWidget( {
    super.key, required this.title, required this.onTap,
  });
  final String  title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          children: [
            Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(56),
                  
                ),
                child:const Center(child: Icon(Icons.add_circle_outline_rounded)),
              ),
             const Gap(8),  
            SizedBox(
              width: 80,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}