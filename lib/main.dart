import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/data/api/api_services.dart';
import 'package:restauran_submission_1/provider/detail/restaurant_detail_provider.dart';
import 'package:restauran_submission_1/provider/favorite/favorite_restaurant_provider.dart';
import 'package:restauran_submission_1/provider/home/restaurant_list_provider.dart';
import 'package:restauran_submission_1/provider/local_notification/local_notification_provider.dart';
import 'package:restauran_submission_1/provider/local_notification/payload_provider.dart';
import 'package:restauran_submission_1/provider/main/index_nav_provider.dart';
import 'package:restauran_submission_1/provider/review/add_review_provider.dart';
import 'package:restauran_submission_1/provider/search/restaurant_search_provider.dart';
import 'package:restauran_submission_1/provider/theme/theme_provider.dart';
import 'package:restauran_submission_1/screen/detail/detail_screen.dart';
import 'package:restauran_submission_1/screen/main/main_screen.dart';
import 'package:restauran_submission_1/services/http_service.dart';
import 'package:restauran_submission_1/services/local_notification_service.dart';
import 'package:restauran_submission_1/services/shared_preferences_service.dart';
import 'package:restauran_submission_1/services/sqlite_service.dart';
import 'package:restauran_submission_1/services/workmanager_service.dart';
import 'package:restauran_submission_1/static/navigation_route.dart';
import 'package:restauran_submission_1/style/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final prefs = await SharedPreferences.getInstance();

  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  String? payload;

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final notificationResponse =
        notificationAppLaunchDetails!.notificationResponse;
    payload = notificationResponse?.payload;
  }
  runApp(MultiProvider(providers: [
    Provider(
      create: (context) => SharedPreferencesService(prefs),
    ),
    Provider(
      create: (context) => WorkmanagerService()..init(),
    ),
    ChangeNotifierProvider(
      create: (context) => IndexNavProvider(),
    ),
    Provider(
      create: (context) => ApiServices(),
    ),
    ChangeNotifierProvider(
      create: (context) => RestaurantListProvider(context.read<ApiServices>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          RestaurantDetailProvider(context.read<ApiServices>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          RestaurantSearchProvider(context.read<ApiServices>()),
    ),
    ChangeNotifierProvider(
      create: (context) => AddReviewProvider(context.read<ApiServices>()),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(
        context.read<SharedPreferencesService>(),
      ),
    ),
    Provider(
      create: (context) => SqliteService(),
    ),
    ChangeNotifierProvider(
      create: (context) => FavoriteRestaurantProvider(
        context.read<SqliteService>(),
      ),
    ),
    Provider(
      create: (context) => HttpService(),
    ),
    Provider(
      create: (context) => LocalNotificationService()
        ..init()
        ..configureLocalTimeZone(),
    ),
    ChangeNotifierProvider(
      create: (context) => LocalNotificationProvider(
        context.read<LocalNotificationService>(),
        context.read<SharedPreferencesService>(),
        context.read<WorkmanagerService>(),
      )
        ..requestPermissions()
        ..checkSavedSheduledReminder(),
    ),
    ChangeNotifierProvider(
      create: (context) => PayloadProvider(payload: payload),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submission Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: RestaurantTheme.lightTheme,
      darkTheme: RestaurantTheme.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
              restaurantId:
                  ModalRoute.of(context)?.settings.arguments as String,
            ),
      },
    );
  }
}
