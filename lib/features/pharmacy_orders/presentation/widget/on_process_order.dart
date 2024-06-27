import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/user_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/neworder_details_view_page.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/quantity_container.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/row_text_widget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/user_detail_container.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';

class OnProcessOrderScreen extends StatelessWidget {
  const OnProcessOrderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: PhysicalModel(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 28,
                            width: 128,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: BColors.darkblue),
                            child: Center(
                              child: Text('Order No-${index + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: Colors.white)),
                            ),
                          ),
                          Container(
                            height: 28,
                            width: 128,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(),
                                color: BColors.offWhite),
                            child: Center(
                              child: Text(
                                '23/01/2024',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
              Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                ListView.builder(
                                  padding: const EdgeInsets.only(
                                    left: 6,
                                    right: 8,
                                    top: 8,
                                  ),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return  Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                'Paracetamol',
                                                overflow: TextOverflow.ellipsis,
                                                style:  Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: BColors.black,
                                          fontWeight: FontWeight.w500, fontSize: 12)
                                                
                                              ),
                                            ),
                                           const  Flexible(
                                                flex: 1,
                                                child: QuantitiyBox(
                                                    productQuantity: '2')),
                                          ],
                                        ),
                                        const Gap(6),
                                      ],
                                    );
                                  },
                                ),
                                                        SizedBox(
                            height: 32,
                            width: 160,
                            child: ElevatedButton(
                              onPressed: () {
                                EasyNavigation.push(
                                  
                                  context: context,
                                  page:  OrderDetailsScreen(index: index,),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: BColors.mainlightColor,
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text('View full details',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const Gap(8)
                              ],
                            ),
                          ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const RowTextContainerWidget(
                              text1: 'Delivery : ',
                              text2: 'Home Delivery',
                              text1Color: BColors.textLightBlack,
                              fontSizeText1: 12,
                              fontSizeText2: 12,
                              fontWeightText1: FontWeight.w600,
                              text2Color: BColors.black,
                            ),

                            const Gap(4),
                            const RowTextContainerWidget(
                              text1: 'Door step charge : ',
                              text2: 'Free Service',
                              text1Color: BColors.textLightBlack,
                              fontSizeText1: 12,
                              fontSizeText2: 12,
                              fontWeightText1: FontWeight.w600,
                              text2Color: BColors.black,
                            ),
                            const Gap(4),
                             RowTextContainerWidget(
                              text1: 'Payment Mode : ',
                              text2: 'COD',
                              text1Color: BColors.textLightBlack,
                              fontSizeText1: 12,
                              fontSizeText2: 12,
                              fontWeightText1: FontWeight.w600,
                              text2Color: BColors.green,
                            ),
                            const Gap(4),
                            const RowTextContainerWidget(
                              text1: 'Payment Status : ',
                              text2: 'Pending',
                              text1Color: BColors.textLightBlack,
                              fontSizeText1: 12,
                              fontSizeText2: 12,
                              fontWeightText1: FontWeight.w600,
                              text2Color: Colors.amber,
                            ),const Gap(4),
                            const RowTextContainerWidget(
                              text1: 'User Status : ',
                              text2: 'Pending',
                              text1Color: BColors.textLightBlack,
                              fontSizeText1: 12,
                              fontSizeText2: 12,
                              fontWeightText1: FontWeight.w600,
                              text2Color: Colors.amber,
                            ),
                            const Gap(4),
                                              
                            RowTextContainerWidget(
                              text1: 'Total items rate : ',
                              text2: "₹ 500",
                              text1Color: BColors.textLightBlack,
                              fontSizeText1: 13,
                              fontSizeText2: 13,
                              fontWeightText1: FontWeight.w600,
                              text2Color: BColors.green,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            text: TextSpan(
                              children: [
                               TextSpan(
                                text: 'Delivery Address : ', // remeber to put space
                                style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          color: BColors.textLightBlack,
                                          fontWeight: FontWeight.w600, fontSize: 12)
                              ),
                              TextSpan(
                                text: 
                                    'KallaniKunnel(H), Kadanad P.O, KavumKandam pincode: 686653',
                                    
                                style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: BColors.black,
                                          fontWeight: FontWeight.w600)
                              ),
                            ]),),
                      const Divider(),
                       UserDetailsContainer(userData: UserModel(),),
                      const Gap(16),
                     SizedBox(
                            height: 40,
                            width: 176,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:BColors.green,
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    
                                      borderRadius: BorderRadius.circular(8))),
                              child: Text('Complete Order',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}