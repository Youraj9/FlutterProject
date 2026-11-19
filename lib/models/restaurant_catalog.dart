import 'restaurant.dart';
import 'restaurant_category.dart';

class RestaurantCatalog {
  const RestaurantCatalog({
    required this.restaurants,
    required this.categories,
  });

  final List<Restaurant> restaurants;
  final List<RestaurantCategory> categories;
}
