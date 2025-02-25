import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/provider/search/restaurant_search_provider.dart';
import 'package:restauran_submission_1/screen/search/search_bar.dart';
import 'package:restauran_submission_1/static/navigation_route.dart';
import 'package:restauran_submission_1/static/restaurant_search_result_state.dart';
import 'package:restauran_submission_1/widget/empty_widget.dart';
import 'package:restauran_submission_1/widget/loading_widget.dart';
import 'package:restauran_submission_1/widget/restaurant_card_widget.dart';

import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (context.mounted) {
        context.read<RestaurantSearchProvider>().searchRestaurant();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<RestaurantSearchProvider>(
          builder: (context, value, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: RestaurantSearchBar(),
                ),
                Expanded(
                  child: switch (value.resultState) {
                    RestaurantSearchLoadingState() => const Center(
                        child: Loading(),
                      ),
                    RestaurantSearchLoadedState(data: var restaurantList) =>
                      restaurantList.isEmpty
                          ? const EmptyIndicator(
                              message: "Restaurant not found",
                              canRefresh: false,
                            )
                          : ListView.builder(
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
                    RestaurantSearchErrorState(error: var message) => Center(
                        child: EmptyIndicator(
                          message: message,
                          onPressed: () => context
                              .read<RestaurantSearchProvider>()
                              .searchRestaurant(),
                        ),
                      ),
                    _ => const SizedBox(),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
