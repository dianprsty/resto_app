import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/data/model/restaurant.dart';
import 'package:restauran_submission_1/data/model/restaurant_detail.dart';
import 'package:restauran_submission_1/helper/asset/image_helper.dart';
import 'package:restauran_submission_1/provider/favorite/favorite_restaurant_provider.dart';
import 'package:restauran_submission_1/screen/detail/widget/about_resto.dart';
import 'package:restauran_submission_1/screen/detail/widget/customer_review_list.dart';
import 'package:restauran_submission_1/screen/detail/widget/menu_list.dart';
import 'package:restauran_submission_1/screen/detail/widget/review_form.dart';

class BodyOfDetailScreenWidget extends StatefulWidget {
  const BodyOfDetailScreenWidget({
    super.key,
    required this.restaurant,
  });

  final RestaurantDetail restaurant;

  @override
  State<BodyOfDetailScreenWidget> createState() =>
      _BodyOfDetailScreenWidgetState();
}

class _BodyOfDetailScreenWidgetState extends State<BodyOfDetailScreenWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<FavoriteRestaurantProvider>()
          .getRestaurantById(widget.restaurant.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final savedProvider = context.watch<FavoriteRestaurantProvider>();
    return CustomScrollView(slivers: [
      SliverAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        expandedHeight: 250,
        pinned: true,
        automaticallyImplyLeading: false,
        titleSpacing: 8,
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.restaurant.name,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface,
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              RestaurantDetail restaurantDetail = widget.restaurant;
              Restaurant restaurant = Restaurant(
                id: restaurantDetail.id,
                name: restaurantDetail.name,
                description: restaurantDetail.description,
                pictureId: restaurantDetail.pictureId,
                city: restaurantDetail.city,
                rating: restaurantDetail.rating,
              );

              final isSaved =
                  context.read<FavoriteRestaurantProvider>().restaurant?.id ==
                      widget.restaurant.id;

              if (isSaved) {
                context
                    .read<FavoriteRestaurantProvider>()
                    .removeRestaurant(widget.restaurant.id);
              } else {
                context
                    .read<FavoriteRestaurantProvider>()
                    .saveRestaurant(restaurant);
              }

              context
                  .read<FavoriteRestaurantProvider>()
                  .getRestaurantById(widget.restaurant.id);
            },
            icon: Icon(
              savedProvider.restaurant?.id == widget.restaurant.id
                  ? Icons.favorite
                  : Icons.favorite_outline,
              color: savedProvider.restaurant?.id == widget.restaurant.id
                  ? Colors.red
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Hero(
            tag: widget.restaurant.pictureId,
            child: Image.network(
              getImageUrl(
                id: widget.restaurant.pictureId,
                size: ImageSize.medium,
              ),
              fit: BoxFit.cover,
            ),
          ),
          expandedTitleScale: 1,
        ),
      ),
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 24,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    spacing: 4,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.restaurant.city,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow.shade700,
                              ),
                              Text(
                                widget.restaurant.rating.toString(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.store,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Expanded(
                            child: Text(
                              widget.restaurant.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AboutResto(restaurant: widget.restaurant),
                  MenuList(restaurant: widget.restaurant),
                  ReviewForm(restaurantId: widget.restaurant.id),
                  CustomerReviewList(restaurant: widget.restaurant)
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
