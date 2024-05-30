
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/core/custom/custom_cached_network/custom_cached_network_image.dart';
import 'package:healthycart_pharmacy/features/add_pharmacy_form_page/application/pharmacy_form_provider.dart';

import 'package:healthycart_pharmacy/utils/constants/image/image.dart';
import 'package:provider/provider.dart';

class ImageFormContainerWidget extends StatelessWidget {
  const ImageFormContainerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Consumer<PharmacyFormProvider>(builder: (context, pharmacyProvider, _) {
        return Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)),
          child: GestureDetector(
              onTap: () {
                pharmacyProvider.getImage();
              },
              child:(pharmacyProvider.imageFile == null &&
                                    pharmacyProvider.imageUrl == null)
                  ? Center(
                      child: Image.asset(
                        BImage.uploadImage,
                        height: 40,
                      ),
                    )
                  : (pharmacyProvider.imageFile != null)? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.file(
                          pharmacyProvider.imageFile!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ): ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CustomCachedNetworkImage(image: pharmacyProvider.imageUrl!, fit: BoxFit.contain,)
                      ),
                    ),
                    ),
        );
      }
    );
  }
}


