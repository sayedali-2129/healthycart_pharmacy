import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';

abstract class IPendingFacade {
  Future<Either<MainFailure, String>> reDirectToWhatsApp({required String whatsAppLink});
}
