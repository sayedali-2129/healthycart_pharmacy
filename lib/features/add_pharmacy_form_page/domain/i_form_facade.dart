import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/add_pharmacy_form_page/domain/model/pharmacy_model.dart';


abstract class IFormFeildFacade {
  FutureResult<String>  addPharmacyDetails({
    required PharmacyModel pharmacyDetails,
    required String pharmacyId,
  });

  FutureResult<File> getImage();
  FutureResult<String> saveImage({
    required File imageFile,
  });
  FutureResult<Unit>  deleteImage({
    required String pharmacyId,
    required String imageUrl,
  });
  FutureResult<String>  updatePharmacyForm({
    required PharmacyModel pharmacyDetails,
    required String pharmacyId,
  });
  FutureResult<File> getPDF();
  FutureResult<String?> savePDF({
    required File pdfFile,
  });
  FutureResult<String?> deletePDF({
    required String pharmacyId,
    required String pdfUrl,
  });
}
