import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/dashboard_settings.dart';
import '../presentation/view_models/auth_view_model.dart';
import '../presentation/view_models/contact_view_model.dart';
import '../presentation/view_models/drone_view_model.dart';
import '../presentation/view_models/graphique_view_model.dart';
import '../presentation/view_models/home_view_model.dart';
import '../presentation/view_models/map_view_model.dart';
import 'services/auth_service.dart';
import 'services/local_database_service.dart';
import 'services/notification_service.dart';
import 'services/preferences_service.dart';
import 'services/user_service.dart';

final getIt = GetIt.instance;

void configureDependencies(SharedPreferences sharedPreferences) {
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<PreferencesService>(
    PreferencesService(sharedPreferences),
  );
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<LocalDatabaseService>(LocalDatabaseService());
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<DashboardSettingsRepository>(
    () => DashboardSettingsRepository(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<IAppUserService>(() => AppUserService());
  getIt.registerLazySingleton<IAuthService>(
    () => AuthService(getIt<IAppUserService>()),
  );
  getIt.registerSingleton<AuthViewModel>(AuthViewModel());
  getIt.registerSingleton<ContactViewModel>(ContactViewModel());
  getIt.registerSingleton<HomeViewModel>(HomeViewModel());
  getIt.registerSingleton<DroneViewModel>(DroneViewModel());
  getIt.registerSingleton<MapViewModel>(MapViewModel());
  getIt.registerFactory<GraphiqueViewModel>(
    () => GraphiqueViewModel(
      getIt<LocalDatabaseService>(),
      getIt<DashboardSettingsRepository>(),
    ),
  );
}
