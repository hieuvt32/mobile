import 'package:background_location/background_location.dart';
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
      if (userId != null) {
        locator<Api>().updateCarLocation(
            employeeAccount: userId,
            longitude: location.longitude!,
            latitude: location.latitude!);
      }
    });
  }
}
