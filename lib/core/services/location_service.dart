import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthycart_pharmacy/core/failures/main_failure.dart';

class LocationService {
    Future<bool> getPermission() async {
    bool isServiceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    await Geolocator.requestPermission();

    if (!isServiceEnabled) {
      // Request to enable location services
      permission = await Geolocator.requestPermission();
    }
    // Check the current permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      // Request permission
      permission = await Geolocator.requestPermission();

      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        // Handle permission denied scenario
        // return const MainFailure.locationError(errMsg: 'Denied location permission');
       return false;
      }
    }

    // If permission is granted temporarily, handle fetching location accordingly
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
     return true;
    }
    return true;
  }

  Future<Either<MainFailure, Placemark>> getCurrentLocationAddress() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark>? place = await GeocodingPlatform.instance
        ?.placemarkFromCoordinates(position.latitude, position.longitude);
    if (place == null) {
      return left(
          const MainFailure.locationError(errMsg: 'Location not found'));
    }
    return right(place.first);
  }
}
