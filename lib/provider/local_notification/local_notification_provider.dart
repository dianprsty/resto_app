import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restauran_submission_1/data/api/api_services.dart';
import 'package:restauran_submission_1/data/model/restaurant.dart';
import 'package:restauran_submission_1/services/local_notification_service.dart';
import 'package:restauran_submission_1/services/workmanager_service.dart';

import '../../services/shared_preferences_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;
  final SharedPreferencesService _service;
  final ApiServices _serviceApi;
  final WorkmanagerService _workmanagerService;

  LocalNotificationProvider(
    this.flutterNotificationService,
    this._service,
    this._serviceApi,
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
    Duration duration =
        flutterNotificationService.nextInstanceOfLunchReminder();
    bool isScheduleSaved = _service.getNotification();
    if (isScheduleSaved) {
      _workmanagerService.runPeriodicTask(duration: duration.abs());
      _isScheduled = true;
      notifyListeners();
    }
  }

  void scheduleLunchReminder() async {
    Duration duration =
        flutterNotificationService.nextInstanceOfLunchReminder();
    var pendingNotifications =
        await flutterNotificationService.pendingNotificationRequests();
    if (pendingNotifications.isEmpty) {
      _workmanagerService.runPeriodicTask(duration: duration.abs());
      _service.setNotification(true);
      _isScheduled = true;
    } else {
      _workmanagerService.cancelAllTask();
      _service.setNotification(false);
      _isScheduled = false;
    }
    notifyListeners();
  }

  // Future<void> checkPendingNotificationRequests(BuildContext context) async {
  //   pendingNotificationRequests =
  //       await flutterNotificationService.pendingNotificationRequests();
  //   notifyListeners();
  // }

  // Future<void> cancelNotification(int id) async {
  //   await flutterNotificationService.cancelNotification(id);
  // }

  // Future<void> getRestaurant() async {
  //   var restaurantResponse = await _serviceApi.getRestaurantList();
  //   var restaurants = restaurantResponse.restaurants;
  //   int index = Random().nextInt(restaurants.length);
  //   _restaurant = restaurants[index];
  //   notifyListeners();
  // }
}
