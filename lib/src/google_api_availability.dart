import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_api_availability/src/models/google_play_services_availability.dart';

import 'models/google_play_services_availability.dart';

/// Flutter plugin to verify if Google Play Services are installed on the
/// device.
class GoogleApiAvailability {
  const GoogleApiAvailability._();

  /// Creates an instance of the [GoogleApiAvailability] class. This
  /// constructor is exposed for testing purposes only and should not be used
  /// by clients of the plugin as it may break or change at any time.
  @visibleForTesting
  const GoogleApiAvailability.private();

  /// Acquires an instance of the [GoogleApiAvailability] class.
  static const GoogleApiAvailability instance = GoogleApiAvailability._();

  static const MethodChannel _methodChannel =
      MethodChannel('flutter.baseflow.com/google_api_availability/methods');

  /// This feature is only available on Android devices. On any other platforms
  /// the [checkPlayServicesAvailability] method will always return
  /// [GooglePlayServicesAvailability.notAvailableOnPlatform].
  Future<GooglePlayServicesAvailability> checkGooglePlayServicesAvailability(
      [bool showDialogIfNecessary = false]) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return GooglePlayServicesAvailability.notAvailableOnPlatform;
    }

    final availability = await _methodChannel.invokeMethod(
        'checkPlayServicesAvailability',
        <String, bool>{'showDialog': showDialogIfNecessary});

    if (availability == null) {
      return GooglePlayServicesAvailability.unknown;
    }

    return GooglePlayServicesAvailability.values[availability];
  }

  /// Returns true if the device was able to set Google Play Services to available.
  /// Returns false if the device was unable to set Google Play Services to available or staus is unknown.
  ///
  /// If it is necessary to display UI in order to complete this request
  /// (e.g. sending the user to the Google Play store) the passed Activity will be used to display this UI.
  Future<bool> makeGooglePlayServicesAvailable() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }

    final availability =
        await _methodChannel.invokeMethod('makeGooglePlayServicesAvailable');

    return availability;
  }
}
