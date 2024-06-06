// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:healthycart_pharmacy/core/general/typdef.dart';

// class ImageUploadServices {
//   static FutureResult<List<String>> uploadListImageStorage({
//     required String imgFolderName,
//     Size compressSize = const Size(720, 1280),
//     required List<XFile> fileList,
//   }) async {
//     try {
//       final byteList =
//           fileList.map((e) => File(e.path).readAsBytesSync()).toList();

//       // Compress byte lists using FlutterImageCompress
//       final futureUint8Lists = <Future<Uint8List>>[];
//       for (final item in byteList) {
//         futureUint8Lists.add(
//           FlutterImageCompress.compressWithList(
//             item,
//             quality: 70, // Lower quality for more aggressive compression
//             minHeight: compressSize.height.toInt(), // Lower minimum height
//             minWidth: compressSize.width.toInt(), // Lower minimum width
//             inSampleSize:
//                 2, // Increase downsampling for more aggressive compression
//           ),
//         );
//       }
//       final uint8Lists = await Future.wait(futureUint8Lists);

//       // Initialize Firebase Storage
//       final storage = FirebaseStorage.instance;

//       // Upload compressed images to Firebase Storage
//       final uploadTask = <UploadTask>[];
//       for (final element in uint8Lists) {
//         final ref = storage
//             .ref()
//             .child(imgFolderName)
//             .child('${Timestamp.now().microsecondsSinceEpoch}.jpeg');
//         uploadTask.add(
//           ref.putData(
//             element,
//             SettableMetadata(contentType: 'image/jpeg'),
//           ),
//         );
//       }
//       final taskSnapshotList = await Future.wait(uploadTask);

//       // Retrieve download URLs from the uploaded images
//       final futureDownloadURL = taskSnapshotList.map(
//         (e) => e.ref.getDownloadURL(),
//       );
//       final urlList = await Future.wait(futureDownloadURL);
//       log('urlList: $urlList');
//       // Return the list of download URLs
//       return right(urlList);
//     } on FirebaseException catch (e) {
//       // Handle Firebase exceptions
//       return left(
//         MainFailure.serverFailure(errorMsg: e.code),
//       );
//     } catch (e) {
//       // Handle other exceptions
//       return left(
//         MainFailure.serverFailure(errorMsg: '$e'),
//       );
//     }
//   }

//   static Future<void> deleteFirebaseStorageFile(
//       List<String> imageUrlList) async {
//     final firebaseStorage = FirebaseStorage.instance;

//     if (imageUrlList.isEmpty) return;

//     try {
//       final functionList = <Future<void>>[];
//       for (final url in imageUrlList) {
//         functionList.add(_checkAndDeleteImage(url, firebaseStorage));
//       }

//       await Future.wait(functionList);
//       log('images deleted successfully');
//     } on Exception catch (e) {
//       showToast(e.toString());
//     }
//   }

//   static Future<void> _checkAndDeleteImage(
//     String imageUrl,
//     FirebaseStorage storage,
//   ) async {
//     try {
//       // Check if the image exists by attempting to get its download URL
//       await storage.refFromURL(imageUrl).getDownloadURL();

//       // If the above line doesn't throw an exception, the image exists
//       // Now you can proceed to delete it
//       await storage.refFromURL(imageUrl).delete();
//     } on FirebaseException catch (e) {
//       if (e.code == 'object-not-found') {
//         // The image doesn't exist, handle accordingly
//         showToast('Image does not exist at $imageUrl');
//       } else {
//         // Handle other Firebase exceptions
//         showToast('F Exception: ${e.message}');
//       }
//     } catch (e) {
//       showToast('$e');
//       // Handle other exceptions
//     }
//   }
// }