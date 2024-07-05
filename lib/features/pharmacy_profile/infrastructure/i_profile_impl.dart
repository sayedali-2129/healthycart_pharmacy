import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';
import 'package:healthycart_pharmacy/core/general/firebase_collection.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/pharmacy_products/domain/model/pharmacy_product_model.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/domain/i_profile_facade.dart';
import 'package:healthycart_pharmacy/features/pharmacy_profile/domain/model/transaction_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IProfileFacade)
class IProfileImpl implements IProfileFacade {
  IProfileImpl(this._firebaseFirestore);
  final FirebaseFirestore _firebaseFirestore;

  @override
  FutureResult<String> setActivePharmacy({
    required bool isPharmacyON,
    required String pharmacyId,
  }) async {
    final batch = _firebaseFirestore.batch();

    try {
      batch.update(
          _firebaseFirestore
              .collection(FirebaseCollections.pharmacy)
              .doc(pharmacyId),
          {'isPharmacyON': isPharmacyON});

      if (isPharmacyON == true) {
        batch.update(
            _firebaseFirestore
                .collection(FirebaseCollections.counts)
                .doc('htfK5JIPTaZVlZi6fGdZ'),
            {
              'activePharmacy': FieldValue.increment(1),
              'inActivePharmacy': FieldValue.increment(-1)
            });
      } else {
        batch.update(
            _firebaseFirestore
                .collection(FirebaseCollections.counts)
                .doc('htfK5JIPTaZVlZi6fGdZ'),
            {
              'activePharmacy': FieldValue.increment(-1),
              'inActivePharmacy': FieldValue.increment(1)
            });
      }

      await batch.commit();

      return right('Successfully updated pharmacy status');
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.code));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

/* ---------------------------- GET ALL PRODUCTS ---------------------------- */
  DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noMoreData = false;
  @override
  FutureResult<List<PharmacyProductAddModel>> getPharmacyAllProductDetails({
    required String pharmacyId,
    required String? searchText,
  }) async {
    try {
      if (noMoreData) return right([]);
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyProduct)
          .orderBy('createdAt', descending: true)
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
/* ---------------------- HOME DELIVERY ENABLE SECTION ---------------------- */
  @override
  FutureResult<String> setPharmacyHomeDelivery(
      {required bool isHomeDeliveryON, required String pharmacyId}) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacy)
          .doc(pharmacyId)
          .update({'isHomeDelivery': isHomeDeliveryON});
         return right('Successfully updated delivery status');  
    } on FirebaseException catch (e) {
      log(e.code);
      log(e.message!);
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  /* --------------------------- TRANSACTION SECTION -------------------------- */
  
  DocumentSnapshot<Map<String, dynamic>>? lastTransactionDoc;
  bool noMoreTransactionData = false;
  @override
  FutureResult<List<TransferTransactionsModel>> getAdminTransactionList(
      {required String pharmacyId}) async {
    if (noMoreTransactionData) return right([]);

    int limit = lastTransactionDoc == null ? 15 : 8;
    try {
      Query query = _firebaseFirestore
          .collection(FirebaseCollections.transactionCollection)
          .doc(pharmacyId)
          .collection(FirebaseCollections.transactionSubCollection)
          .orderBy('dateAndTime', descending: true);

      // if (search != null && search.isNotEmpty) {
      //   query = query.where('keywords', arrayContains: search.toLowerCase());
      // }
      if (lastTransactionDoc != null) {
        query = query.startAfterDocument(lastTransactionDoc!);
      }
      final result = await query.limit(limit).get();

      if (result.docs.length < limit || result.docs.isEmpty) {
        noMoreTransactionData = true;
      } else {
        lastTransactionDoc = result.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }

      final transactionList = result.docs
          .map((e) => TransferTransactionsModel.fromMap(
              e.data() as Map<String, dynamic>))
          .toList();

      return right(transactionList);
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearTransactionData() {
    lastTransactionDoc = null;
    noMoreTransactionData = false;
  }

}
