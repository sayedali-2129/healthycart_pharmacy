import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/custom_appbar_curve.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/application/provider/request_pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/cancelled_order.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/completed_order.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/new_order.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/on_process_order.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/tab_bar_horizontal.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestPharmacyProvider>(builder: (context, state, _) {
      return CustomScrollView(
        slivers: [
          const CustomSliverCurveAppBarWidget(),
          HorizontalTabBarWidget(
            state: state,
          ),
          if(state.tabIndex == 0)
             const NewOrderScreen()
          else if(state.tabIndex == 1)
          const OnProcessOrderScreen()
          else if(state.tabIndex == 2)
           const CompletedOrderScreen()
          else
          const CancelledOrderScreen() 
        ],
      );
    });
  }
}
