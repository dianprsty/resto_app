import 'dart:developer';

import 'package:restauran_submission_1/services/local_notification_service.dart';
import 'package:restauran_submission_1/static/my_workmanager.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == MyWorkmanager.oneOff.taskName ||
        task == MyWorkmanager.oneOff.uniqueName) {
      final localNotification = LocalNotificationService();
      await localNotification.init();
      await localNotification.configureLocalTimeZone();

      bool isFirst = inputData?["isFirst"] ?? false;
      final duration = localNotification.nextInstanceOfLunchReminder();

      // if (isFirst && duration.inMinutes > -15) {
      //   log("first task");
      //   WorkmanagerService()
      //       .runOneOffTask(duration: duration.abs(), isFirst: false);
      // }

      WorkmanagerService().runPeriodicTask(duration: duration.abs());

      // if (!isFirst) {
      //   log("not first task");
      //   await localNotification.showNotification(id: 1);
      // }

      print(
          "duration hour ${duration.inHours} minutes ${duration.inMinutes} seconds ${duration.inSeconds}");
    } else if (task == MyWorkmanager.periodic.taskName ||
        task == MyWorkmanager.periodic.uniqueName) {
      final localNotification = LocalNotificationService();
      await localNotification.init();

      await localNotification.showNotification(id: 1);
    }
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

  Future<void> runOneOffTask(
      {Duration duration = Duration.zero, bool isFirst = true}) async {
    await _workmanager.registerOneOffTask(
        MyWorkmanager.oneOff.uniqueName, MyWorkmanager.oneOff.taskName,
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        initialDelay: duration,
        inputData: {"isFirst": isFirst});
  }

  Future<void> runPeriodicTask({Duration duration = Duration.zero}) async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(minutes: 16),
      initialDelay: duration,
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
