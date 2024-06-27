import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';
import 'package:healthycart_pharmacy/core/general/firebase_collection.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/core/services/image_picker.dart';
import 'package:healthycart_pharmacy/features/pharmacy_banner/domain/i_banner_facade.dart';
import 'package:healthycart_pharmacy/features/pharmacy_banner/domain/model/pharmacy_banner_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IBannerFacade)
class IBannerImpl implements IBannerFacade {
  IBannerImpl(this._firebaseFirestore, this._imageService);
  final FirebaseFirestore _firebaseFirestore;
  final ImageService _imageService;

  @override
  FutureResult<File> getImage() async {
    return await _imageService.getGalleryImage();
  }

  @override
  FutureResult<String> saveImage({required File imageFile}) async {
    return await _imageService.saveImage(imageFile: imageFile, folderName: 'pharmacy_banner');
  }

  @override
  FutureResult<Unit> deleteImage({required String imageUrl}) async {
    return await _imageService.deleteImageUrl(imageUrl: imageUrl);
  }

  @override
  FutureResult<PharmacyBannerModel> addPharmacyBanner(
      {required PharmacyBannerModel banner}) async {
    try {
      final CollectionReference collRef =
          _firebaseFirestore.collection(FirebaseCollections.pharmacyBanner);
      String id = collRef.doc().id;
      banner.id = id;
      await collRef.doc(id).set(banner.toMap());
      return right(banner.copyWith(id: id));
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<List<PharmacyBannerModel>> getPharmacyBanner(
      {required String pharmacyId}) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyBanner)
          .orderBy('isCreated', descending: true)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .get();
      return right([
        ...snapshot.docs.map(
            (e) => PharmacyBannerModel.fromMap(e.data()).copyWith(id: e.id))
      ]);
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.toString()));
    }
  }

  @override
  FutureResult<PharmacyBannerModel> deletePharmacyBanner(
      {required PharmacyBannerModel banner}) async {
    try {
      final id = banner.id;
      final CollectionReference collRef =
          _firebaseFirestore.collection(FirebaseCollections.pharmacyBanner);
      await collRef.doc(id).delete();
      return right(banner.copyWith(id: id));
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.toString()));
    }
  }
}
