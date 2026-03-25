import 'package:go_router/go_router.dart';

import '../../data/models/drone_model.dart';
import '../../presentation/views/contact_page.dart';
import '../../presentation/views/battery_page.dart';
import '../../presentation/views/drone_list_page.dart';
import '../../presentation/views/drone_search_page.dart';
import '../../presentation/views/home_page.dart';
import '../../presentation/views/location_map.dart';
import '../../presentation/views/login_page.dart';
import '../../presentation/views/permissions_page.dart';
import '../../presentation/views/register_page.dart';
import '../../presentation/views/remote_connection_page.dart';
import '../../presentation/views/settings_page.dart';
import '../../presentation/views/welcome_page.dart';
import '../di.dart';
import '../notifiers/auth_notifier.dart';
import '../services/auth_service.dart';
import '../services/preferences_service.dart';
import 'app_routes.dart';

final authNotifier = AuthNotifier(getIt<IAuthService>(), getIt<PreferencesService>());

final List<String> unauthenticatedRoutes = [
  AppRoutes.welcome,
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.permissions,
  AppRoutes.remoteConnection,
  AppRoutes.droneSearch,
];

final GoRouter appRouter = GoRouter(
  refreshListenable: authNotifier,
  initialLocation: AppRoutes.welcome,
  redirect: (context, state) {
    final bool loggedIn = authNotifier.isAuthenticated;
    final bool hasSeenWelcome = authNotifier.hasSeenWelcome;
    
    if (!hasSeenWelcome && state.matchedLocation != AppRoutes.welcome) {
      return AppRoutes.welcome;
    }

    if (!loggedIn) {
      if (!unauthenticatedRoutes.contains(state.matchedLocation)) {
        return AppRoutes.login;
      }
      return null;
    }

    final bool needsSetup = !authNotifier.hasCompletedSetup; 

    if (needsSetup) {
      if (state.matchedLocation != AppRoutes.permissions) {
        return AppRoutes.permissions;
      }
      return null;
    }

    if (state.matchedLocation == AppRoutes.login || 
        state.matchedLocation == AppRoutes.welcome ||
        state.matchedLocation == AppRoutes.register) {
      return AppRoutes.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.contact,
      name: 'contact',
      builder: (context, state) => const ContactPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.location,
      name: 'location',
      builder: (context, state) => const LocationPage(),
    ),
    GoRoute(
      path: AppRoutes.droneList,
      name: 'droneList',
      builder: (context, state) => const DroneListPage(),
    ),
    GoRoute(
      path: AppRoutes.battery,
      name: 'battery',
      builder: (context, state) {
        final drone = state.extra as DroneModel;
        return BatteryPage(drone: drone);
      },
    ),
    GoRoute(
      path: AppRoutes.welcome,
      name: 'welcome',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: AppRoutes.permissions,
      name: 'permissions',
      builder: (context, state) => const PermissionsPage(),
    ),
    GoRoute(
      path: AppRoutes.remoteConnection,
      name: 'remoteConnection',
      builder: (context, state) => const RemoteConnectionPage(),
    ),
    GoRoute(
      path: AppRoutes.droneSearch,
      name: 'droneSearch',
      builder: (context, state) => const DroneSearchPage(),
    ),
  ],
);
