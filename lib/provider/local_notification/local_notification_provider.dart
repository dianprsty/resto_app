import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restauran_submission_1/services/local_notification_service.dart';
import 'package:restauran_submission_1/services/workmanager_service.dart';

import '../../services/shared_preferences_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;
  final SharedPreferencesService _service;
  final WorkmanagerService _workmanagerService;

  LocalNotificationProvider(
    this.flutterNotificationService,
    this._service,
    this._workmanagerService,
  );

  final int _notificationId = 1;
  bool? _permission = false;
  bool _isScheduled = false;
  bool? get permission => _permission;

  List<PendingNotificationRequest> pendingNotificationRequests = [];

  bool getNotification() => _isScheduled;

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  void showNotification() {
    flutterNotificationService.showNotification(id: _notificationId);
  }

  void checkSavedSheduledReminder() async {
    bool isScheduleSaved = _service.getNotification();
    if (isScheduleSaved) {
      _workmanagerService.runPeriodicTask();
      _isScheduled = true;
      notifyListeners();
    }
  }

  void scheduleLunchReminder() async {
    bool isActive = _service.getNotification();
    if (!isActive) {
      _workmanagerService.runPeriodicTask();
      _service.setNotification(true);
      _isScheduled = true;
    } else {
      _workmanagerService.cancelAllTask();
      _service.setNotification(false);
      _isScheduled = false;
    }
    notifyListeners();
  }
}
