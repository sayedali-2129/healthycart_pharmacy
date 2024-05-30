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
import 'package:injectable/injectable.dart';

@LazySingleton(as: IPharmacyFacade)
class IPharmacyImpl implements IPharmacyFacade {
  IPharmacyImpl(this._firebaseFirestore, this._imageService);
  final FirebaseFirestore _firebaseFirestore;
  final ImageService _imageService;
//// Image section --------------------------
  @override
  FutureResult<File> getImage() async {
    return await _imageService.getGalleryImage();
  }

  @override
  FutureResult<String> saveImage({required File imageFile}) async {
    return await _imageService.saveImage(imageFile: imageFile, folderName: 'pharmacy_category');
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
      log('Category of hospitals::::::${categoryList.length.toString()}');

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
      log('User Id:::::$pharmacyId CategoryId::::: ${category.id}');
      log('${category.id}');
      if (pharmacyId == null) {
        return left(
            const MainFailure.firebaseException(errMsg: 'check userid'));
      }
      log('User id for updating category');
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
      log('Category id for deleting category ::: $categoryId');
      log('User id for deleting category ::: $pharmacyId');
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
          .where('hospitalId', isEqualTo: pharmacyId)
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
  }) async {
    try {
      final id = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .doc()
          .id;
      productData.id = id;
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .doc(id)
          .set(productData.toMap());
      log('Doctor id :::::: $id');
      return right(productData.copyWith(id: id));
    } on FirebaseException catch (e) {
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<List<PharmacyProductAddModel>> getPharmacyProductDetails({
    required String categoryId,
    required String pharmacyId,
  }) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .orderBy('createdAt')
          .where('categoryId', isEqualTo: categoryId)
          .where('hospitalId', isEqualTo: pharmacyId)
          .get();
      log(' Implementation of get doctor called  :::: ');
      return right(snapshot.docs
          .map((e) =>
              PharmacyProductAddModel.fromMap(e.data()).copyWith(id: e.id))
          .toList());
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<PharmacyProductAddModel> deletePharmacyProductDetails({
    required String pharmacyId,
    required PharmacyProductAddModel productData,
  }) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .doc(pharmacyId)
          .delete();

      log(' Deletion of doctor called  :::: ');
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
    required String pharmacyId,
    required PharmacyProductAddModel productData,
  }) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .doc(pharmacyId)
          .update(productData.toMap());

      log(' Updating  of get pharmacy called  :::: ');
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
  FutureResult<List<File>> getProductImageList({required int maxImages}) async {
    return await _imageService.getMultipleGalleryImage( maxImages: maxImages);
  }

  @override
  FutureResult<List<String>> saveProductImageList(
      {required List<File> imageFileList}) async {
    List<String> imageUrlList = [];
    for (var imageFile in imageFileList) {
      await _imageService.saveImage(imageFile: imageFile, folderName: 'pharmacy_product').then((result) {
        result.fold((failure) {
          return left(failure);
        }, (imageUrl) {
          imageUrlList.add(imageUrl);
        });
      });
    }
    return right(imageUrlList);
  }
}
