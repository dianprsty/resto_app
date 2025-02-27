import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/data/model/received_notification.dart';
import 'package:restauran_submission_1/provider/local_notification/local_notification_provider.dart';
import 'package:restauran_submission_1/provider/local_notification/payload_provider.dart';
import 'package:restauran_submission_1/services/local_notification_service.dart';
import 'package:restauran_submission_1/static/navigation_route.dart';

import '../../services/workmanager_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      context.read<PayloadProvider>().payload = payload;
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      final payload = receivedNotification.payload;
      context.read<PayloadProvider>().payload = payload;
      Navigator.pushNamed(context, NavigationRoute.detailRoute.name,
          arguments: receivedNotification.payload);
    });
  }

  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Permission",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _requestPermission();
                    },
                    child: Consumer<LocalNotificationProvider>(
                      builder: (context, value, child) {
                        return Text(
                          value.permission != null &&
                                  (value.permission ?? false)
                              ? 'Granted'
                              : 'Not Allowed',
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Lunch Reminder",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Switch(
                    value: context
                        .watch<LocalNotificationProvider>()
                        .getNotification(),
                    onChanged: (value) => _scheduleLunchReminder(),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _runBackgroundOneOffTask();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  "Test Run notification",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _runBackgroundOneOffTask() async {
    context.read<WorkmanagerService>().runOneOffTask();
  }

  Future<void> _requestPermission() async {
    context.read<LocalNotificationProvider>().requestPermissions();
  }

  Future<void> _scheduleLunchReminder() async {
    context.read<LocalNotificationProvider>().scheduleLunchReminder();
  }
}
