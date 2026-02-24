import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/connection/presentation/screens/chat_room_screen.dart';
import '../../features/connection/presentation/screens/identity_reveal_screen.dart';
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
        path: '/food-feed/:personaId',
        builder: (context, state) {
          final personaId = state.pathParameters['personaId']!;
          return FoodFeedScreen(personaId: personaId);
        },
      ),
      GoRoute(
        path: '/identity-reveal/:personaId',
        builder: (context, state) {
          final personaId = state.pathParameters['personaId']!;
          return IdentityRevealScreen(personaId: personaId);
        },
      ),
      GoRoute(
        path: '/chat/:recipientId',
        builder: (context, state) {
          final recipientId = state.pathParameters['recipientId']!;
          return ChatRoomScreen(recipientId: recipientId);
        },
      ),
    ],
  );
}
