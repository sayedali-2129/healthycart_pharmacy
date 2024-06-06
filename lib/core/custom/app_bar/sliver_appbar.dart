import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/search_field_button.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class SliverCustomAppbar extends StatelessWidget {
  const SliverCustomAppbar({
    super.key,
    required this.title, required this.onBackTap, this.child,
  });
  final String title;
  final VoidCallback onBackTap;
  final PreferredSizeWidget? child;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor:  BColors.mainlightColor,
      titleSpacing: -6,
      pinned: true,
      floating: true,
      forceElevated: true,
      toolbarHeight: 80,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      leading: IconButton(
          onPressed:onBackTap,
          icon: const Icon(Icons.arrow_back_ios, color:BColors.darkblue ,)),

      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: BColors.darkblue, fontWeight: FontWeight.w700,fontSize: 18 )),
  
      bottom: child
    );
  }
}