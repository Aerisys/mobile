import 'package:get_it/get_it.dart';

import '../presentation/view_models/auth_view_model.dart';
import '../presentation/view_models/contact_view_model.dart';
import '../presentation/view_models/home_view_model.dart';
import 'services/auth_service.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton<IAuthService>(() => FirebaseAuthService());
  getIt.registerSingleton<AuthViewModel>(AuthViewModel());
  getIt.registerSingleton<ContactViewModel>(ContactViewModel());
  getIt.registerSingleton<HomeViewModel>(HomeViewModel());
}
