import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:restauran_submission_1/services/local_notification_service.dart';
import 'package:restauran_submission_1/static/my_workmanager.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final localNotification = LocalNotificationService();
    await localNotification.init();
    await localNotification.showNotification(id: 1);
    return Future.value(true);
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager])
      : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<void> runOneOffTask({Duration initDelay = Duration.zero}) async {
    await _workmanager.registerOneOffTask(
      MyWorkmanager.oneOff.uniqueName,
      MyWorkmanager.oneOff.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: initDelay,
    );
  }

  Future<void> runPeriodicTask() async {
    Duration frequency = const Duration(days: 1);
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var additionalDay = now.isAfter(
            tz.TZDateTime(tz.local, now.year, now.month, now.day, 11, 00))
        ? 1
        : 0;
    tz.TZDateTime nextNotification = tz.TZDateTime(
        tz.local, now.year, now.month, now.day + additionalDay, 11, 00);

    var diff = nextNotification.difference(now);

    if (diff.inMinutes <= 15) {
      runOneOffTask(initDelay: diff);
      diff = Duration(days: 1, minutes: diff.inMinutes);
    }

    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: frequency,
      flexInterval: Duration(minutes: 10),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      initialDelay: diff,
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
