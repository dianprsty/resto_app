import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/helper/async/async_helper.dart';
import 'package:restauran_submission_1/provider/search/restaurant_search_provider.dart';

class RestaurantSearchBar extends StatefulWidget {
  const RestaurantSearchBar({
    super.key,
  });

  @override
  State<RestaurantSearchBar> createState() => _RestaurantSearchBarState();
}

class _RestaurantSearchBarState extends State<RestaurantSearchBar> {
  final _debouncer = Debouncer(duration: Durations.long2);
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _handleSearch(BuildContext context, String query) {
    _debouncer.run(() {
      context.read<RestaurantSearchProvider>().setSearchQuery(query);
      context.read<RestaurantSearchProvider>().searchRestaurant();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<RestaurantSearchProvider>().setSearchQuery("");
    context.read<RestaurantSearchProvider>().searchRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        hintText: "Search Restaurant",
        suffixIcon: context.watch<RestaurantSearchProvider>().query.isEmpty
            ? null
            : GestureDetector(
                onTap: () => _clearSearch(),
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red.shade600,
                ),
              ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) => _handleSearch(context, value),
      onChanged: (value) => _handleSearch(context, value),
      maxLines: 1,
    );
  }
}
