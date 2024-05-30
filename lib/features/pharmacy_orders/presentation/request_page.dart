import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/custom_appbar_curve.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/application/provider/request_doctor_provider.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:healthycart_pharmacy/utils/constants/image/image.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestDoctorProvider>(builder: (context, state, _) {
      return CustomScrollView(
        slivers: [
          const CustomSliverCurveAppBarWidget(),
          HorizontalTabBarWidget(
            state: state,
          ),
          SliverPadding(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child: Text('Booking No-1',
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),
                            const DoctorRoundImageNameWidget(),
                            const Gap(8),
                            const RowTextContainerWidget(
                                text1: 'Date selected',
                                text2: 'Today',
                                tabWidth: 104,
                                gap: 24),
                            const Gap(8),
                            const RowTextContainerWidget(
                                text1: 'Time slot',
                                text2: '9.00 AM To 12:00 PM',
                                tabWidth: 152,
                                gap: 56),
                            const Gap(8),
                            const UserDetailsContainer(),
                            const Gap(8),
                            Text(
                              'Set the booking time',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Gap(8),
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade300),
                              child: Center(
                                child: Text(
                                  'Click here to set time slot',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12),
                                ),
                              ),
                            ),
                            const Gap(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 136,
                                  child: ElevatedButton(
                                    onPressed: () {},
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
                                    onPressed: () {},
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
                );
              },
            ),
          )
        ],
      );
    });
  }
}

class UserDetailsContainer extends StatelessWidget {
  const UserDetailsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jassel Ck',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RowTwoTextWidget(text1: 'Age', text2: '25', gap: 48),
                      Gap(8),
                      RowTwoTextWidget(text1: 'Gender', text2: 'Male', gap: 24),
                      Gap(8),
                      RowTwoTextWidget(
                          text1: 'Phone No', text2: '+919569845632', gap: 8),
                    ],
                  ),
                ),
                const Gap(12),
                PhysicalModel(
                    elevation: 2,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.location_on_sharp,
                                  size: 24,
                                  color: Colors.blue,
                                ))))),
                const Gap(8),
                PhysicalModel(
                    elevation: 2,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.phone,
                                    size: 24, color: Colors.blue))))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RowTwoTextWidget extends StatelessWidget {
  const RowTwoTextWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.gap,
  });
  final String text1;
  final String text2;
  final double gap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text1,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(gap),
        Text(
          text2,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class RowTextContainerWidget extends StatelessWidget {
  const RowTextContainerWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.tabWidth,
    required this.gap,
  });
  final String text1;
  final String text2;
  final double tabWidth;
  final double gap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text1,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(gap),
        Container(
          height: 30,
          width: tabWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: BColors.mainlightColor),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text2,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.white,
                      )),
            ),
          ),
        ),
      ],
    );
  }
}

class HorizontalTabBarWidget extends StatelessWidget {
  const HorizontalTabBarWidget({
    super.key,
    required this.state,
  });
  final RequestDoctorProvider state;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      pinned: true,
      shadowColor: Colors.grey[400],
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white70,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomElevatedTabButton(
                backgroundColor: (state.tabIndex == 0)
                    ? const Color(0xFF11334E)
                    : Colors.white,
                onPressed: () {
                  state.changeTabINdex(index: 0);
                },
                child: Text('New Request',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: (state.tabIndex == 0)
                              ? Colors.white
                              : Colors.black,
                        )),
              ),
              CustomElevatedTabButton(
                backgroundColor: (state.tabIndex == 1)
                    ? const Color(0xFF11334E)
                    : Colors.white,
                onPressed: () {
                  state.changeTabINdex(index: 1);
                },
                child: Text('On Process',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: (state.tabIndex == 1)
                              ? Colors.white
                              : Colors.black,
                        )),
              ),
              CustomElevatedTabButton(
                backgroundColor: (state.tabIndex == 2)
                    ? const Color(0xFF11334E)
                    : Colors.white,
                onPressed: () {
                  state.changeTabINdex(index: 2);
                },
                child: Text('Visited',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: (state.tabIndex == 2)
                              ? Colors.white
                              : Colors.black,
                        )),
              ),
            ],
          ),
        ),
      ),
    );
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
                  borderRadius: BorderRadius.circular(14))),
          child: child,
        ),
      ),
    );
  }
}

class DoctorRoundImageNameWidget extends StatelessWidget {
  const DoctorRoundImageNameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(56),
              image: const DecorationImage(image: AssetImage(BImage.otpImage))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr Meenakshi Kallara, MBBS,PHD',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              Text(
                '(Neurologist)',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        )
      ],
    );
  }
}
