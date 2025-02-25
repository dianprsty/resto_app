import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/provider/detail/restaurant_detail_provider.dart';
import 'package:restauran_submission_1/screen/detail/widget/body_of_detail_screen_widget.dart';
import 'package:restauran_submission_1/static/restaurant_detail_result_state.dart';
import 'package:restauran_submission_1/widget/empty_widget.dart';
import 'package:restauran_submission_1/widget/loading_widget.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RestaurantDetailProvider>().resetExpanded();
      context
          .read<RestaurantDetailProvider>()
          .fetchRestaurantDetail(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantDetailLoadingState() => const Center(
                child: Loading(),
              ),
            RestaurantDetailLoadedState(data: var restaurant) =>
              BodyOfDetailScreenWidget(restaurant: restaurant),
            RestaurantDetailErrorState(error: var message) => Center(
                child: EmptyIndicator(
                  message: message,
                  onPressed: () => context
                      .read<RestaurantDetailProvider>()
                      .fetchRestaurantDetail(widget.restaurantId),
                ),
              ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
