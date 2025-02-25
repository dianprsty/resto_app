import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/provider/favorite/favorite_restaurant_provider.dart';
import 'package:restauran_submission_1/provider/home/restaurant_list_provider.dart';
import 'package:restauran_submission_1/static/navigation_route.dart';
import 'package:restauran_submission_1/widget/empty_widget.dart';
import 'package:restauran_submission_1/widget/loading_widget.dart';
import 'package:restauran_submission_1/widget/restaurant_card_widget.dart';

import '../../static/restaurant_list_result_state.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FavoriteRestaurantProvider>().getAllRestaurant();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Restaurants"),
      ),
      body: Consumer<FavoriteRestaurantProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantListLoadingState() => const Center(
                child: Loading(),
              ),
            RestaurantListLoadedState(data: var restaurantList) =>
              restaurantList.isEmpty
                  ? Center(
                      child: const EmptyIndicator(
                        message: 'Favorite restaurant is empty',
                        canRefresh: false,
                      ),
                    )
                  : ListView.builder(
                      itemCount: restaurantList.length,
                      itemBuilder: (context, index) {
                        final restaurant = restaurantList[index];

                        return RestaurantCard(
                          isFavorite: true,
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
