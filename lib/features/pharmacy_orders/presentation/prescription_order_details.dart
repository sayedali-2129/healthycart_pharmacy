import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/sliver_appbar.dart';
import 'package:healthycart_pharmacy/core/custom/custom_alertbox/confirm_alertbox_widget.dart';
import 'package:healthycart_pharmacy/core/custom/custom_alertbox/textfield_alertbox.dart';
import 'package:healthycart_pharmacy/core/custom/custom_buttons_and_search/common_button.dart';
import 'package:healthycart_pharmacy/core/custom/image_view/image_view.dart';
import 'package:healthycart_pharmacy/core/custom/lottie/loading_lottie.dart';
import 'package:healthycart_pharmacy/core/custom/toast/toast.dart';
import 'package:healthycart_pharmacy/core/services/easy_navigation.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/application/provider/request_pharmacy_provider.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/pharmacy_order_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/user_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/prescription_product_list.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/address_card.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/date_and_order_id.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/product_list_widget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/row_text_widget.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/presentation/widget/user_detail_container.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PrescriptionOrderDetailsScreen extends StatelessWidget {
  const PrescriptionOrderDetailsScreen({
    super.key,
    required this.data,
    required this.index,
  });

  final PharmacyOrderModel data;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<RequestPharmacyProvider>(
        builder: (context, orderProvider, _) {
      final orderData = data;
      return Scaffold(
        body: PopScope(
          canPop: (orderData.productDetails?.length ==
              orderProvider.pharmacyUserProducts.length),
          onPopInvoked: (didPop) {
            if (orderData.productDetails?.length !=
                orderProvider.pharmacyUserProducts.length) {
              ConfirmAlertBoxWidget.showAlertConfirmBox(
                  context: context,
                  confirmButtonTap: () {
                    EasyNavigation.pop(context: context);
                    orderProvider.clearFiledAndData();
                  },
                  titleText: 'Remove all changes',
                  subText: "Are you sure to undo all the changes?");
            } else {
              orderProvider.clearFiledAndData();
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverCustomAppbar(
                  title: 'Order Details',
                  onBackTap: () {
                    if (orderData.productDetails?.length !=
                        orderProvider.pharmacyUserProducts.length) {
                      ConfirmAlertBoxWidget.showAlertConfirmBox(
                          context: context,
                          confirmButtonTap: () {
                            EasyNavigation.pop(context: context);
                            orderProvider.clearFiledAndData();
                          },
                          titleText: 'Remove all changes',
                          subText: "Are you sure to undo all the changes?");
                    } else {
                      EasyNavigation.pop(context: context);
                      orderProvider.clearFiledAndData();
                    }
                  }),
              SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 6.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              OrderIDAndDateSection(
                                orderData: orderData,
                                date: orderProvider
                                    .dateFromTimeStamp(orderData.createdAt!),
                              ),
                              const Gap(8),
                              const Divider(),
                              if (orderProvider.pharmacyUserProducts.isNotEmpty)
                                Column(
                                  children: [
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ProductDetailsWidget(
                                          detailsPage: true,
                                          index: index,
                                          productData: orderProvider
                                              .pharmacyUserProducts[index],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider();
                                      },
                                      itemCount: orderProvider
                                          .pharmacyUserProducts.length,
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              CustomButton(
                                width: double.infinity,
                                height: 40,
                                onTap: () {
                                  EasyNavigation.push(
                                      context: context,
                                      type: PageTransitionType.rightToLeft,
                                      page: const PrescriptionProductList());
                                },
                                text: 'Add Product',
                                buttonColor: BColors.lightgreen,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        color: BColors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                icon: Icons.add,
                                iconSize: 28,
                                iconColor: BColors.black,
                              ),
                              if(orderData.description != '' || orderData.description != null)
                              
                              Column(
                                children: [
                                   const Gap(16),
                                   
                                 
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: BColors.offRed),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: 'Customer Note : ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontSize: 12,
                                                ),
                                        ),
                                        TextSpan(
                                            text: ' ${orderData.description}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .copyWith(
                                                    fontSize: 13,
                                                    color: BColors.textBlack,
                                                    fontWeight: FontWeight.w600)),

                                      ]),
                                    ),
                                  ),
                                  const Gap(8),
                                ],
                              ),
                              Column(
                                children: [
                                  const Divider(),
                                  (orderData.addresss != null &&
                                          orderData.deliveryType == "Home")
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Delivery Address : ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: BColors
                                                          .textLightBlack,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                            ),
                                            const Gap(8),
                                            Expanded(
                                              child: AddressCard(
                                                  addressData:
                                                      orderData.addresss!),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pick-Up Address : ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: BColors
                                                          .textLightBlack,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                            ),
                                            const Gap(8),
                                            Expanded(
                                              child: Text(
                                                '${orderData.pharmacyDetails?.pharmacyName ?? 'Pharmacy'}-${orderData.pharmacyDetails?.pharmacyAddress ?? 'Pharmacy'}',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color:
                                                            BColors.textBlack,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ),
                                  const Divider(),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.loose,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RowTextContainerWidget(
                                          text1: 'Delivery :',
                                          text2: orderProvider.deliveryType(
                                              orderData.deliveryType ?? ''),
                                          text1Color: BColors.textLightBlack,
                                          fontSizeText1: 12,
                                          fontSizeText2: 12,
                                          fontWeightText1: FontWeight.w600,
                                          text2Color: BColors.black,
                                        ),
                                        const Gap(8),
                                        (orderData.prescription != null &&
                                                orderData
                                                    .prescription!.isNotEmpty)
                                            ? const Column(
                                                children: [
                                                  RowTextContainerWidget(
                                                    text1: 'Prescription :',
                                                    text2: 'Included',
                                                    text1Color:
                                                        BColors.textLightBlack,
                                                    fontSizeText1: 12,
                                                    fontSizeText2: 12,
                                                    fontWeightText1:
                                                        FontWeight.w600,
                                                    text2Color: BColors.black,
                                                  ),
                                                  Gap(8),
                                                ],
                                              )
                                            : const SizedBox(),
                                        RowTextContainerWidget(
                                          text1: 'Total Amount :',
                                          text2:
                                              "₹ ${orderProvider.totalAmount}",
                                          text1Color: BColors.textLightBlack,
                                          fontSizeText1: 12,
                                          fontSizeText2: 12,
                                          fontWeightText1: FontWeight.w600,
                                          text2Color: BColors.textBlack,
                                        ),
                                        const Gap(8),
                                        RowTextContainerWidget(
                                          text1: 'Total Discount :',
                                          text2:
                                              "- ₹ ${orderProvider.totalAmount - orderProvider.totalFinalAmount}",
                                          text1Color: BColors.textLightBlack,
                                          fontSizeText1: 12,
                                          fontSizeText2: 12,
                                          fontWeightText1: FontWeight.w600,
                                          text2Color: BColors.green,
                                        ),
                                        if (orderData.deliveryType == 'Home')
                                          Column(
                                            children: [
                                              const Gap(8),
                                              RowTextContainerWidget(
                                                text1: 'Delivery Charge :',
                                                text2: (orderProvider
                                                                .deliveryCharge ==
                                                            0 ||
                                                        orderProvider
                                                                .deliveryCharge ==
                                                            null)
                                                    ? "Free Delivery"
                                                    : '₹ ${orderProvider.deliveryCharge}',
                                                text1Color:
                                                    BColors.textLightBlack,
                                                fontSizeText1: 12,
                                                fontSizeText2: 12,
                                                fontWeightText1:
                                                    FontWeight.w600,
                                                text2Color: (orderProvider
                                                                .deliveryCharge ==
                                                            0 ||
                                                        orderProvider
                                                                .deliveryCharge ==
                                                            null)
                                                    ? BColors.green
                                                    : BColors.textBlack,
                                              ),
                                              const Gap(8),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: InkWell(
                                                  onTap: () {
                                                    orderProvider
                                                        .deliveryController
                                                        .clear();
                                                    TextFieldAlertBoxWidget
                                                        .showAlertTextFieldBox(
                                                      context: context,
                                                      confirmButtonTap: () {
                                                        orderProvider
                                                            .setDeliveryCharge();
                                                        EasyNavigation.pop(
                                                            context: context);
                                                      },
                                                      titleText:
                                                          'Home Delivery Charge',
                                                      hintText:
                                                          'Enter the delivery charge',
                                                      subText:
                                                          'Please enter a delivery amount or leave it blank if the delivery is free.',
                                                      controller: orderProvider
                                                          .deliveryController,
                                                      maxlines: 1,
                                                      keyboardType:
                                                          TextInputType.number,
                                                    );
                                                  },
                                                  child: Text(
                                                    'Add delivery Charge',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          color:
                                                              BColors.darkblue,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        const Divider(),
                                        RowTextContainerWidget(
                                          text1: 'Amount To Be Paid : ',
                                          text2:
                                              "₹ ${orderProvider.totalFinalAmount}",
                                          text1Color: BColors.textBlack,
                                          fontSizeText1: 13,
                                          fontSizeText2: 14,
                                          fontWeightText1: FontWeight.w600,
                                          text2Color: BColors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(12),
                                ],
                              ),
                              const Divider(),
                              if (orderData.prescription != null &&
                                  orderData.prescription!.isNotEmpty)
                                CustomButton(
                                  width: 160,
                                  height: 40,
                                  onTap: () {
                                    EasyNavigation.push(
                                      context: context,
                                      type: PageTransitionType.rightToLeft,
                                      page: ImageView(
                                        imageUrl: orderData.prescription!,
                                      ),
                                    );
                                  },
                                  text: 'View Prescription',
                                  buttonColor: BColors.darkblue,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                ),
                              const Gap(12),
                              UserDetailsContainer(
                                userData: orderData.userDetails ?? UserModel(),
                              ),
                              const Gap(16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 136,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        TextFieldAlertBoxWidget
                                            .showAlertTextFieldBox(
                                                context: context,
                                                confirmButtonTap: () {
                                                  if (orderProvider
                                                      .rejectionReasonController
                                                      .text
                                                      .isEmpty) {
                                                    return CustomToast.errorToast(
                                                        text:
                                                            'Please enter reason for the cancelling order');
                                                  }
                                                  EasyNavigation.pop(
                                                      context: context);
                                                  LoadingLottie.showLoading(
                                                      context: context,
                                                      text: 'Please wait...');
                                                  orderProvider
                                                      .updateNewOrderDetails(
                                                          context: context,
                                                          productData:
                                                              orderData,
                                                          cancelOrApprove: 3);
                                                },
                                                titleText: 'Confirm To Cancel',
                                                hintText:
                                                    'Enter the reason for cancel',
                                                subText:
                                                    'Are you sure to cancel the order ?',
                                                controller: orderProvider
                                                    .rejectionReasonController,
                                                maxlines: 5);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(),
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      child: Text('Cancel',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 136,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (orderProvider
                                            .pharmacyUserProducts.isEmpty) {
                                          return CustomToast.errorToast(
                                              text:
                                                  "Can't approve since there is no items added.");
                                        }
                                        ConfirmAlertBoxWidget
                                            .showAlertConfirmBox(
                                                context: context,
                                                confirmButtonTap: () {
                                                  LoadingLottie.showLoading(
                                                      context: context,
                                                      text: 'Please wait...');
                                                  orderProvider
                                                      .updateNewOrderDetails(
                                                          context: context,
                                                          productData:
                                                              orderData,
                                                          cancelOrApprove: 1);
                                                },
                                                titleText: 'Confirm the order',
                                                subText: (orderData
                                                            .deliveryType ==
                                                        'Home')
                                                    ? 'Please tap yes to confirm this order as a Home Delivery order.'
                                                    : 'Please tap yes to confirm this order as a Pick-Up at pharmacy order.');
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          surfaceTintColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      child: Text('Approve',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      );
    });
  }
}
