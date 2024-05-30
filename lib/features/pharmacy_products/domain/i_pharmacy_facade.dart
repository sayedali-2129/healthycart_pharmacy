import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_category_model.dart';

abstract class IPharmacyFacade {
  FutureResult<File> getImage();
  FutureResult<String>  saveImage({
    required File imageFile,
  });
  FutureResult<Unit>  deleteImage({
    required String imageUrl,
  });
 FutureResult<List<PharmacyCategoryModel>>  getPharmacyCategoryAll();

  FutureResult<List<PharmacyCategoryModel>>
      getpharmacyCategory({
    required List<String> categoryIdList,
  });

  FutureResult<PharmacyCategoryModel> updatePharmacyCategoryDetails({
    required String pharmacyId,
    required PharmacyCategoryModel category,
  });

  FutureResult<PharmacyCategoryModel>deletePharmacyCategory({
    required String pharmacyId,
    required PharmacyCategoryModel category,
  });

  FutureResult<bool> checkProductInsidePharmacyCategory({
    required String categoryId,
    required String pharmacyId,
  });

  Future<Either<MainFailure, PharmacyProductAddModel>> addPharmacyProductDetails({
    required PharmacyProductAddModel productData,
  });

  Future<Either<MainFailure, List<PharmacyProductAddModel>>> getPharmacyProductDetails({
    required String categoryId,
    required String pharmacyId,
  });

  Future<Either<MainFailure, PharmacyProductAddModel>> deletePharmacyProductDetails({
    required String pharmacyId,
    required PharmacyProductAddModel productData,
  });

  Future<Either<MainFailure, PharmacyProductAddModel>> updatePharmacyProductDetails({
    required String pharmacyId,
    required PharmacyProductAddModel productData,
  });

   FutureResult<List<File>> getProductImageList({required int maxImages});
     FutureResult<List<String>>  saveProductImageList({
    required List<File> imageFileList,
  });
  
}
