import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class AddProductImageWidget extends StatelessWidget {
  const AddProductImageWidget({
    super.key,
    required this.addTap,
    required this.child,
    required this.height,
    required this.width, 
  });
  final VoidCallback addTap;
  final Widget child;
  final double height;
  final double width;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: addTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border.all(color:  BColors.grey),
            borderRadius: BorderRadius.circular(8),
            shape: BoxShape.rectangle
        ),
        child: child
    ));
  }
}
