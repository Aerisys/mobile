import 'package:get_it/get_it.dart';

import 'services/auth_service.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton<IAuthService>(() => FirebaseAuthService());
}
