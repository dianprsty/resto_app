import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/data/model/restaurant_detail.dart';
import 'package:restauran_submission_1/helper/async/async_helper.dart';
import 'package:restauran_submission_1/helper/extension/context_extension.dart';
import 'package:restauran_submission_1/provider/detail/restaurant_detail_provider.dart';
import 'package:restauran_submission_1/provider/review/add_review_provider.dart';
import 'package:restauran_submission_1/screen/detail/widget/review_card.dart';
import 'package:restauran_submission_1/static/add_review_result_state.dart';

class CustomerReviewList extends StatefulWidget {
  const CustomerReviewList({
    super.key,
    required this.restaurant,
  });

  final RestaurantDetail restaurant;

  @override
  State<CustomerReviewList> createState() => _CustomerReviewListState();
}

class _CustomerReviewListState extends State<CustomerReviewList> {
  final debouncer = Debouncer(duration: Durations.extralong1);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AddReviewProvider>().reset();
    });
  }

  @override
  void dispose() {
    debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final addReviewProvider = context.read<AddReviewProvider>();
      final resultState = addReviewProvider.resultState;
      if (resultState is AddReviewErrorState) {
        context.showSnackbar(
          message: resultState.error,
          backgroundColor: Colors.red.shade700,
        );

        addReviewProvider.removeError();
      }
    });

    final restaurantDetailProvider = context.watch<RestaurantDetailProvider>();
    final isExpanded = restaurantDetailProvider.isExpandedReview;

    var displayedRating = widget.restaurant.customerReviews;
    final resultState = context.watch<AddReviewProvider>().resultState;

    displayedRating = switch (resultState) {
      AddReviewLoadedState(data: var reviews) =>
        reviews.isNotEmpty ? reviews : displayedRating,
      _ => displayedRating,
    };

    displayedRating = displayedRating.reversed.toList();
    final canSeeMore = displayedRating.length > 5;

    if (canSeeMore && !isExpanded) {
      displayedRating = displayedRating.sublist(0, 5);
    }
    return Consumer<AddReviewProvider>(
      child: Column(children: [
        ...displayedRating.map((review) => ReviewCard(review: review)),
        canSeeMore
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: GestureDetector(
                  onTap: () => restaurantDetailProvider.toggleExpandedReview(),
                  child: Text(
                    isExpanded ? "Show Less" : "Show More",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ]),
      builder: (context, value, child) {
        return child!;
      },
    );
  }
}
