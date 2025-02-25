import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/helper/async/async_helper.dart';
import 'package:restauran_submission_1/helper/extension/context_extension.dart';
import 'package:restauran_submission_1/provider/review/add_review_provider.dart';
import 'package:restauran_submission_1/static/add_review_result_state.dart';

class ReviewForm extends StatefulWidget {
  final String restaurantId;
  const ReviewForm({
    super.key,
    required this.restaurantId,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  final _debouncer = Debouncer(duration: Durations.extralong1);

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) async {
    final addReviewProvider = context.read<AddReviewProvider>();
    if (addReviewProvider.id.isEmpty ||
        addReviewProvider.name.isEmpty ||
        addReviewProvider.review.isEmpty) {
      _debouncer.run(() {
        context.showSnackbar(
          message: "Please fill in all fields",
          backgroundColor: Colors.red.shade700,
        );
      });
      return;
    }

    await addReviewProvider.addReview();
    if (addReviewProvider.resultState is AddReviewLoadedState) {
      _nameController.clear();
      _reviewController.clear();
      context.showSnackbar(
        message: "Review added successfully",
        backgroundColor: Theme.of(context).colorScheme.primary,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AddReviewProvider>().id = widget.restaurantId;
    });
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Customer Review",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              TextField(
                controller: _nameController,
                enabled: context.watch<AddReviewProvider>().resultState
                    is! AddReviewLoadingState,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) =>
                    context.read<AddReviewProvider>().name = value,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                maxLines: 1,
              ),
              TextField(
                controller: _reviewController,
                enabled: context.watch<AddReviewProvider>().resultState
                    is! AddReviewLoadingState,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) =>
                    context.read<AddReviewProvider>().review = value,
                decoration: InputDecoration(
                  labelText: "Review",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                minLines: 3,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),
                  Flexible(
                    child: ElevatedButton(
                        onPressed: () => _handleSubmit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 16,
                          ),
                          minimumSize: const Size(140, 40),
                        ),
                        child: context.watch<AddReviewProvider>().resultState
                                is AddReviewLoadingState
                            ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : Text(
                                "Submit Review",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                textAlign: TextAlign.center,
                              )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
