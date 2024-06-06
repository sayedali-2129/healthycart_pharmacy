import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';
import 'package:healthycart_pharmacy/core/general/firebase_collection.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/core/services/image_picker.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/i_pharmacy_facade.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_category_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/product_type_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPharmacyFacade)
class IPharmacyImpl implements IPharmacyFacade {
  IPharmacyImpl(this._firebaseFirestore, this._imageService);
  final FirebaseFirestore _firebaseFirestore;
  final ImageService _imageService;
//// Image section --------------------------
  @override
  FutureResult<List<File>> getProductImageList({required int maxImages}) async {
    return await _imageService.getMultipleGalleryImage(maxImages: maxImages);
  }

  @override
  FutureResult<List<String>> saveProductImageList(
      {required List<File> imageFileList}) async {
    List<String> imageUrlList = [];
    for (var imageFile in imageFileList) {
      await _imageService
          .saveImage(imageFile: imageFile, folderName: 'pharmacy_product')
          .then((result) {
        result.fold((failure) {
          return left(failure);
        }, (imageUrl) {
          imageUrlList.add(imageUrl);
        });
      });
    }
    return right(imageUrlList);
  }

  @override
  FutureResult<Unit> deleteImage({required String imageUrl}) async {
    return await _imageService.deleteImageUrl(imageUrl: imageUrl);
  }

//////////// add and get category----------------------------------
  @override
  FutureResult<List<PharmacyCategoryModel>> getPharmacyCategoryAll() async {
    try {
      final snapshot = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacycategory)
          .orderBy('isCreated', descending: true)
          .get();
      return right([
        ...snapshot.docs.map(
            (e) => PharmacyCategoryModel.fromMap(e.data()).copyWith(id: e.id))
      ]);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

//////////////// getting the list of pharmacy selected categories here
  @override
  FutureResult<List<PharmacyCategoryModel>> getpharmacyCategory(
      {required List<String> categoryIdList}) async {
    try {
      List<Future<DocumentSnapshot<Map<String, dynamic>>>> futures = [];

      for (var element in categoryIdList) {
        futures.add(_firebaseFirestore
            .collection(FirebaseCollections.pharmacycategory)
            .doc(element)
            .get());
      }

      List<DocumentSnapshot<Map<String, dynamic>>> results =
          await Future.wait<DocumentSnapshot<Map<String, dynamic>>>(futures);

      final categoryList = results
          .map<PharmacyCategoryModel>((e) =>
              PharmacyCategoryModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();

      return right(categoryList);
    } on FirebaseException catch (e) {
      log(e.toString());
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      log(e.toString());

      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<PharmacyCategoryModel> updatePharmacyCategoryDetails({
    required String? pharmacyId,
    required PharmacyCategoryModel category,
  }) async {
    try {
      if (pharmacyId == null) {
        return left(
            const MainFailure.firebaseException(errMsg: 'check userid'));
      }
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacy)
          .doc(pharmacyId)
          .update({
        'selectedCategoryId': FieldValue.arrayUnion([category.id])
      });
      return right(category);
    } on FirebaseException catch (e) {
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  ///////////delete category----------------------------------
  @override
  FutureResult<PharmacyCategoryModel> deletePharmacyCategory({
    required String? pharmacyId,
    required PharmacyCategoryModel category,
  }) async {
    try {
      if (pharmacyId == null) {
        return left(
            const MainFailure.firebaseException(errMsg: 'Check user Id'));
      }
      final categoryId = category.id;
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacy)
          .doc(pharmacyId)
          .update({
        'selectedCategoryId': FieldValue.arrayRemove([categoryId])
      });
      return right(category);
    } on FirebaseException catch (e) {
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  // this is to check if there is data inside the selected category, if yes to inform before the category is deleted.
  @override
  FutureResult<bool> checkProductInsidePharmacyCategory({
    required String categoryId,
    required String pharmacyId, // pharmacy id is the user id
  }) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .where('categoryId', isEqualTo: categoryId)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .get();
      return right(snapshot.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  //////////////////////// doctor add section------------------------------------------
  @override
  FutureResult<PharmacyProductAddModel> addPharmacyProductDetails({
    required PharmacyProductAddModel productData,
    required Map<String, dynamic> productMapData,
  }) async {
    try {
      final id = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .doc()
          .id;
      productMapData.update('id', (value) => id);
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .doc(id)
          .set(productMapData);
      return right(productData.copyWith(id: id));
    } on FirebaseException catch (e) {
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noMoreData = false;
  @override
  FutureResult<List<PharmacyProductAddModel>> getPharmacyProductDetails({
    required String categoryId,
    required String pharmacyId,
    required String? searchText,
  }) async {
    try {
      if (noMoreData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .orderBy('createdAt', descending: true)
          .where('categoryId', isEqualTo: categoryId)
          .where('pharmacyId', isEqualTo: pharmacyId);

      if (searchText != null && searchText.isNotEmpty) {
        query =
            query.where('keywords', arrayContains: searchText.toLowerCase());
      }
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
        log(lastDoc!.id.toString());
      }
      final snapshots = await query.limit(6).get();
      if (snapshots.docs.length < 6 || snapshots.docs.isEmpty) {
        noMoreData = true;
      } else {
        lastDoc = snapshots.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final List<PharmacyProductAddModel> productList = snapshots.docs
          .map((e) =>
              PharmacyProductAddModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();
      return right(productList);
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearFetchData() {
    noMoreData = false;
    lastDoc = null;
  }

  @override
  FutureResult<PharmacyProductAddModel> deletePharmacyProductDetails({
    required String productId,
    required PharmacyProductAddModel productData,
  }) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .doc(productId)
          .delete();

      log(' Deletion of pharmacy called  :::: ');
      return right(productData);
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<PharmacyProductAddModel> updatePharmacyProductDetails({
    required String productId,
    required PharmacyProductAddModel productData,
    required Map<String, dynamic> productMapData, 
  }) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .doc(productId)
          .update(productMapData);

      log('Updating  of get pharmacy called  :::: ');
      
      return right(productData);
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<MedicineData> getMedicineFormAndPackageList() async {
    try {
      List<String>? productPackage;
      List<String>? productForm;
      await _firebaseFirestore
          .collection(FirebaseCollections.productsForm)
          .doc('medicine')
          .get()
          .then((value) {
        var data = value.data() as Map<String, dynamic>;
        List<dynamic> medicineFormList = data['medicineFormList'];
        List<dynamic> medicinePackageList = data['medicinePackageList'];
        productForm = medicineFormList.map((item) {
          return item['medicineForm'] as String;
        }).toList();
        productPackage = medicinePackageList.map((item) {
          return item['medicinePackage'] as String;
        }).toList();
      });
      if (productPackage != null && productForm != null) {
        return right(MedicineData(
            productForm: productForm ?? [],
            productPackage: productPackage ?? []));
      } else {
        return left(const MainFailure.generalException(
            errMsg: "Couldn't able to get the data."));
      }
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<Unit> deletePharmacyImageList(
      {required List<String> imageUrlList}) async {
    return await _imageService.deleteFirebaseStorageListUrl(imageUrlList);
  }
}
