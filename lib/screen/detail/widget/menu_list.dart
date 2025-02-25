import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restauran_submission_1/data/model/restaurant_detail.dart';
import 'package:restauran_submission_1/helper/asset/image_helper.dart';
import 'package:restauran_submission_1/provider/detail/restaurant_detail_provider.dart';
import 'package:restauran_submission_1/screen/detail/widget/section_title.dart';

class MenuList extends StatefulWidget {
  const MenuList({
    super.key,
    required this.restaurant,
  });

  final RestaurantDetail restaurant;

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    final restaurantDetailProvider = context.watch<RestaurantDetailProvider>();
    final isExpanded = restaurantDetailProvider.isExpandedAMenu;
    final menuType = restaurantDetailProvider.menuType;

    var displayedMenu = menuType == MenuType.food
        ? widget.restaurant.menus.foods
        : widget.restaurant.menus.drinks;

    final canSeeMore = displayedMenu.length > 5;

    if (displayedMenu.length > 4 && !isExpanded) {
      displayedMenu = displayedMenu.sublist(0, 4);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        SectionTitle(title: "Menu"),
        Row(
          spacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: () =>
                  restaurantDetailProvider.setMenuType(MenuType.food),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: menuType == MenuType.food
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
              ),
              icon: Icon(
                Icons.fastfood,
                color: menuType == MenuType.food
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                "Makanan",
                style: TextStyle(
                    color: menuType == MenuType.food
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () =>
                  restaurantDetailProvider.setMenuType(MenuType.drink),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: menuType == MenuType.drink
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
              ),
              icon: Icon(
                Icons.wine_bar,
                color: menuType == MenuType.drink
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                "Minuman",
                style: TextStyle(
                    color: menuType == MenuType.drink
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        GridView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: displayedMenu.length,
          shrinkWrap: true,
          primary: false,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              childAspectRatio: 5 / 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4),
          itemBuilder: (context, index) {
            final menu = menuType == MenuType.food
                ? widget.restaurant.menus.foods[index]
                : widget.restaurant.menus.drinks[index];
            return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Image.asset(
                        getLocalImagePath(
                            name: menuType == MenuType.food
                                ? "food.png"
                                : "beverages.png"),
                        width: 35,
                      ),
                      Expanded(
                          child: Text(
                        menu.name,
                      )),
                    ],
                  ),
                ));
          },
        ),
        canSeeMore
            ? GestureDetector(
                onTap: () => restaurantDetailProvider.toggleExpandedMenu(),
                child: Text(
                  isExpanded ? "Show Less" : "Show More",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
