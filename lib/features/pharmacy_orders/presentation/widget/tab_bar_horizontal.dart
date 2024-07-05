import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/application/provider/request_pharmacy_provider.dart';

class HorizontalTabBarWidget extends StatelessWidget {
  const HorizontalTabBarWidget({
    super.key,
    required this.state,
  });
  final RequestPharmacyProvider state;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      forceElevated: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        pinned: true,
        shadowColor: Colors.grey[400],
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white70,
        title: SizedBox(
          height: 72,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            itemCount: state.tabItems.length,
            itemBuilder: (context, index) {
              return CustomElevatedTabButton(
                backgroundColor: (state.tabIndex == index)
                    ? const Color(0xFF11334E)
                    : Colors.white,
                onPressed: () {
                  state.changeTabINdex(index: index);
        
                },
                child: Text(state.tabItems[index],
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: (state.tabIndex == index)
                              ? Colors.white
                              : Colors.black,
                        ),),
              );
            },
          ),
        ));
  }
}

class CustomElevatedTabButton extends StatelessWidget {
  const CustomElevatedTabButton({
    super.key,
    required this.backgroundColor,
    required this.child,
    required this.onPressed,
  });

  final Color backgroundColor;
  final Widget child;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16),
      child: SizedBox(
        height: 40,
        width: 136,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: backgroundColor,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

