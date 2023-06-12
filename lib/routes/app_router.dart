import 'package:go_router/go_router.dart';
import 'package:rick_morty_flutter_app/api/api.dart';
import 'package:rick_morty_flutter_app/detail/detail_personaje_page.dart';
import 'package:rick_morty_flutter_app/favorites/favorites.dart';
import 'package:rick_morty_flutter_app/login/login.dart';
import 'package:rick_morty_flutter_app/main/main.dart';
import 'package:rick_morty_flutter_app/signup/signup.dart';
import 'package:rick_morty_flutter_app/splash/splash.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (_, __) => const SignupPage(),
    ),
    GoRoute(
      path: '/main',
      builder: (_, __) => const MainPage(),
    ),
    GoRoute(
      path: '/detail-personaje',
      builder: (_, state) => DetailPersonajePage(
        args: state.extra! as DetailPersonajeArgs,
      ),
    ),
    GoRoute(
      path: '/favorites',
      builder: (_, state) => const FavoritesPage(),
    ),
  ],
);
