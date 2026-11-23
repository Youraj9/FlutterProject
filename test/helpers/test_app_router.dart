import 'package:go_router/go_router.dart';
import 'package:sideproject/models/auth_user.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/screens/Homescreen.dart';
import 'package:sideproject/screens/Mainpage.dart';
import 'package:sideproject/screens/Orderscreen.dart';
import 'package:sideproject/screens/Resdetails.dart';
import 'package:sideproject/screens/Searchscreen.dart';
import 'package:sideproject/screens/cardscreen.dart';
import 'package:sideproject/services/cart_store.dart';
import 'package:sideproject/services/order_refresh_store.dart';
import 'package:sideproject/services/order_service.dart';
import 'package:sideproject/services/restaurant_service.dart';

GoRouter createTestAppRouter({
  String initialLocation = '/home',
  AuthUser? user,
  CartStore? cartStore,
  OrderService? orderService,
  RestaurantService? restaurantService,
}) {
  final cart = cartStore ?? CartStore();

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => HomeScreen1(
                  user: user,
                  onOpenCart: () => context.go('/cart'),
                  cartStore: cart,
                  restaurantService: restaurantService,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => SearchScreen(
                  onBack: () => context.go('/home'),
                  onOpenCart: () => context.go('/cart'),
                  cartStore: cart,
                  restaurantService: restaurantService,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => Cardscreen1(
                  onBack: () => context.go('/home'),
                  onOrderPlaced: (_) {
                    OrderRefreshStore.instance.refresh();
                    context.go('/orders');
                  },
                  cartStore: cart,
                  orderService: orderService,
                  restaurantService: restaurantService,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                builder: (context, state) => OrdersScreen(
                  onBack: () => context.go('/home'),
                  orderService: orderService,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/restaurants/:restaurantId',
        builder: (context, state) {
          final navigation = state.extra;
          if (navigation is RestaurantDetailsNavigation) {
            return RestaurantDetailsScreen(
              restaurant: navigation.restaurant,
              cartStore: navigation.cartStore,
              onOpenCart: navigation.onOpenCart,
              restaurantService: navigation.restaurantService,
            );
          }
          final restaurant = navigation;
          if (restaurant is Restaurant) {
            return RestaurantDetailsScreen(
              restaurant: restaurant,
              cartStore: cart,
              restaurantService: restaurantService,
              onOpenCart: () => context.go('/cart'),
            );
          }
          return RestaurantDetailsRoute(
            restaurantId: state.pathParameters['restaurantId']!,
            cartStore: cart,
            onOpenCart: () => context.go('/cart'),
            restaurantService: restaurantService,
          );
        },
      ),
    ],
  );
}
