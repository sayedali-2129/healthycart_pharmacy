import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';
import 'package:healthycart_pharmacy/core/general/firebase_collection.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart'; 
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/i_order_facade.dart';
import 'package:healthycart_pharmacy/features/pharmacy_orders/domain/model/pharmacy_order_model.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: IOrderFacade)
class IOrderImpl implements IOrderFacade {
  IOrderImpl(this._firebaseFirestore);
  final FirebaseFirestore _firebaseFirestore;

  late StreamSubscription _streamSubscription;
  @override
  Stream<Either<MainFailure, List<PharmacyOrderModel>>> pharmacyNewOrderData({
    required String pharmacyId,
  }) async* {
    final StreamController<Either<MainFailure, List<PharmacyOrderModel>>>
        newOrderStreamController =
        StreamController<Either<MainFailure, List<PharmacyOrderModel>>>();
    try {
      _streamSubscription = _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .orderBy('createdAt', descending: true)
          .where(Filter.and(
            Filter('pharmacyId', isEqualTo: pharmacyId),
            Filter('orderStatus', isEqualTo: 0),
          ))
          .snapshots()
          .listen(
        (docsList) {
          final newOrderList = docsList.docs
              .map((e) =>
                  PharmacyOrderModel.fromMap(e.data()).copyWith(id: e.id))
              .toList();
          log('Data fetched::');
          newOrderStreamController.add(right(newOrderList));
        },
      );
    } on FirebaseException catch (e) {
      newOrderStreamController
          .add(left(MainFailure.firebaseException(errMsg: e.code)));
    } catch (e) {
      newOrderStreamController
          .add(left(MainFailure.generalException(errMsg: e.toString())));
    }
    yield* newOrderStreamController.stream;
  }

  @override
  Future<void> cancelStream() async {
    await _streamSubscription.cancel();
  }

  /* ------------------------- UPDATE IN PENDING ORDER ------------------------ */
    @override
  FutureResult<PharmacyOrderModel> updateProductOrderDetails(
      {required String orderId,
      required PharmacyOrderModel orderProducts}) async {
    log(orderId);
    try {
      await _firebaseFirestore
          .collection(FirebaseCollections.pharmacyOrder)
          .doc(orderId)
          .update(orderProducts.toMap());

      return right(orderProducts.copyWith(id: orderId));
    } on FirebaseException catch (e) {
      return left(MainFailure.firebaseException(errMsg: e.message.toString()));
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }
}
