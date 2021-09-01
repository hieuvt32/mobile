import 'package:background_location/background_location.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:frappe_app/app/locator.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/utils/helpers.dart';
import 'package:injectable/injectable.dart';

import 'api/api.dart';

@lazySingleton
class BackgroundLocationService {
  Future startLocationService() async {
    await requestLocationPermission();

    await BackgroundLocation.startLocationService(distanceFilter: 50);

    String? userId = Config().userId;

    BackgroundLocation.getLocationUpdates((location) {
      print("location ${location.latitude}");
      if (userId != null) {
        EasyDebounce.debounce(
            'update-car-location', // <-- An ID for this particular debouncer
            Duration(milliseconds: 500), // <-- The debounce duration
            () => locator<Api>().updateCarLocation(
                employeeAccount: userId,
                longitude: location.longitude!,
                latitude: location.latitude!) // <-- The target method
            );
      }
    });
  }

  Future stopLocationService() async {
    await BackgroundLocation.stopLocationService();
  }
}
