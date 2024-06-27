import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/pharmacy_banner/domain/model/pharmacy_banner_model.dart';

abstract class IBannerFacade {
  FutureResult<File> getImage();
  FutureResult<String> saveImage({
    required File imageFile,
  });
  FutureResult<Unit> deleteImage({
    required String imageUrl,
  });
  FutureResult<PharmacyBannerModel> addPharmacyBanner({
    required PharmacyBannerModel banner,
  });
  FutureResult<PharmacyBannerModel> deletePharmacyBanner({
    required PharmacyBannerModel banner,
  });
  FutureResult<List<PharmacyBannerModel>> getPharmacyBanner({
    required String pharmacyId,
  });
}
