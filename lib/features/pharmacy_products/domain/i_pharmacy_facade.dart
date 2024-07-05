import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_category_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/product_type_model.dart';

abstract class IPharmacyFacade {
  FutureResult<List<File>> getProductImageList({required int maxImages});
  FutureResult<List<String>> saveProductImageList({
    required List<File> imageFileList,
  });
  FutureResult<Unit> deleteImage({
    required String imageUrl,
  });
  FutureResult<List<PharmacyCategoryModel>> getPharmacyCategoryAll();

  FutureResult<List<PharmacyCategoryModel>> getpharmacyCategory({
    required List<String> categoryIdList,
  });

  FutureResult<PharmacyCategoryModel> updatePharmacyCategoryDetails({
    required String pharmacyId,
    required PharmacyCategoryModel category,
  });

  FutureResult<PharmacyCategoryModel> deletePharmacyCategory({
    required String pharmacyId,
    required PharmacyCategoryModel category,
  });

  FutureResult<bool> checkProductInsidePharmacyCategory({
    required String categoryId,
    required String pharmacyId,
  });

  FutureResult<PharmacyProductAddModel> addPharmacyProductDetails({
    required PharmacyProductAddModel productData,
    required Map<String, dynamic> productMapData,
  });

  FutureResult<List<PharmacyProductAddModel>> getPharmacyProductDetails({
    required String categoryId,
    required String pharmacyId,
    required String? searchText,
  });
  
  void clearFetchData();

  FutureResult<PharmacyProductAddModel> deletePharmacyProductDetails({
    required String productId,
    required PharmacyProductAddModel productData,
  });

  FutureResult<Unit> deleteProductImageList({
    required List<String> imageUrlList,
    
  });

  FutureResult<PharmacyProductAddModel> updatePharmacyProductDetails({
    required String productId,
    required PharmacyProductAddModel productData,
    required Map<String, dynamic> productMapData,
  });
  FutureResult<bool> setStatusOfProductStock({
    required bool isProductInStock,
    required String productId,
  });
  FutureResult<MedicineData> getproductFormAndPackageList();
}
