import 'package:dartz/dartz.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';
import 'package:healthycart_pharmacy/core/general/typdef.dart';
import 'package:healthycart_pharmacy/features/location_picker/domain/model/location_model.dart';

abstract class ILocationFacade {
  Future<bool> getLocationPermisson();
  Future<Either<MainFailure, PlaceMark?>> getCurrentLocationAddress();

  FutureResult<List<PlaceMark>?> getSearchPlaces(String query);

  Future<Either<MainFailure, Unit>> setLocationByPharmacy(PlaceMark placeMark);

  Future<Either<MainFailure, Unit>> updateUserLocation(PlaceMark placeMark, String userId);
}
