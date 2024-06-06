import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthycart_pharmacy/core/custom/app_bar/clip_path_appbar_custom.dart';
import 'package:healthycart_pharmacy/utils/constants/colors/colors.dart';
import 'package:healthycart_pharmacy/utils/constants/image/image.dart';

// class CustomCurveAppBarWidget extends StatelessWidget {
//   const CustomCurveAppBarWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: CustomCurvedEdges(),
//       child: Container(
//         width: double.infinity,
//         height: 104,
//         decoration: BoxDecoration(
//           color: BColors.mainlightColor,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Align(
//             alignment: Alignment.bottomCenter,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Gap(32),
//                 Image.asset(
//                   height: 40,
//                   BImage.roundLogo,
//                   fit: BoxFit.fill,
//                 ),
//                 const Gap(12),
//                 Text(
//                   'HEALTHY CART',
//                   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                       letterSpacing: 1,
//                       color: BColors.darkblue,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 const Gap(24),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class CustomSliverCurveAppBarWidget extends StatelessWidget {
  const CustomSliverCurveAppBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
     automaticallyImplyLeading: false,
      leadingWidth: 0,
      pinned: true,
      toolbarHeight: 104,
      backgroundColor: BColors.mainlightColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              height: 40,
              BImage.roundLogo,
              fit: BoxFit.fill,
            ),
            const Gap(12),
            Text(
              'HEALTHY CART',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                letterSpacing: 1,
                  color: BColors.darkblue, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
