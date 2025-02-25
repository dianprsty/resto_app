import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/data/model/restaurant_detail.dart';
import 'package:restauran_submission_1/provider/detail/restaurant_detail_provider.dart';
import 'package:restauran_submission_1/screen/detail/widget/section_title.dart';

class AboutResto extends StatelessWidget {
  final RestaurantDetail restaurant;

  const AboutResto({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantDetailProvider = context.watch<RestaurantDetailProvider>();
    final isExpanded = restaurantDetailProvider.isExpandedAbout;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        SectionTitle(title: "About Resto"),
        Text(
          restaurant.description,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.justify,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          maxLines: isExpanded ? null : 3,
        ),
        GestureDetector(
          onTap: () => restaurantDetailProvider.toggleExpandedAbout(),
          child: Text(
            isExpanded ? "Show Less" : "Show More",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      ],
    );
  }
}
