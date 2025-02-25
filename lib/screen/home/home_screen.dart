import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/provider/home/restaurant_list_provider.dart';
import 'package:restauran_submission_1/provider/theme/theme_provider.dart';
import 'package:restauran_submission_1/static/navigation_route.dart';
import 'package:restauran_submission_1/widget/empty_widget.dart';
import 'package:restauran_submission_1/widget/loading_widget.dart';
import 'package:restauran_submission_1/widget/restaurant_card_widget.dart';

import '../../static/restaurant_list_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurants"),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          )
        ],
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantListLoadingState() => const Center(
                child: Loading(),
              ),
            RestaurantListLoadedState(data: var restaurantList) =>
              ListView.builder(
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];

                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.detailRoute.name,
                        arguments: restaurant.id,
                      );
                    },
                  );
                },
              ),
            RestaurantListErrorState(error: var message) => Center(
                child: EmptyIndicator(
                    message: message,
                    onPressed: () => context
                        .read<RestaurantListProvider>()
                        .fetchRestaurantList()),
              ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
