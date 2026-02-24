import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/matching/presentation/screens/food_feed_screen.dart';
import '../../features/persona/presentation/screens/discovery_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DiscoveryScreen(),
      ),
      GoRoute(
        path: '/food-feed',
        builder: (context, state) => const FoodFeedScreen(),
      ),
    ],
  );
}
