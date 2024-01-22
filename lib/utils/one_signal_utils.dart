import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:socialv/main.dart';
import 'package:socialv/utils/app_constants.dart';

Future<void> initOneSignal() async {
  OneSignal.initialize(ONESIGNAL_APP_ID);
  OneSignal.Notifications.requestPermission(true);
  OneSignal.User.pushSubscription.optIn();
  saveOneSignalPlayerId();

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    OneSignal.Notifications.displayNotification(event.notification.notificationId);
    return event.notification.display();
  });
  OneSignal.User.pushSubscription.addObserver((stateChanges) async {
    if (stateChanges.current.id.validate().isNotEmpty) {
      setValue(SharePreferencesKey.ONE_SIGNAL_PLAYER_ID, stateChanges.current.id.validate());
    }
  });
}

Future<void> saveOneSignalPlayerId() async {
  if (appStore.isLoggedIn) {
    await OneSignal.login(appStore.loginUserId.toString()).then((value) {
      if (OneSignal.User.pushSubscription.id.validate().isNotEmpty) {
        setValue(SharePreferencesKey.ONE_SIGNAL_PLAYER_ID, OneSignal.User.pushSubscription.id.validate());
      }
    }).catchError((e) {
      log('Error saving subscription id - $e');
    });
  }
}
