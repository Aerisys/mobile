import 'package:firebase_core/firebase_core.dart'; // 1. Import Firebase Core
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/view_model/auth_view_model.dart';
import 'presentation/view_model/contact_view_model.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  final token = await FirebaseMessaging.instance.getToken();
  final notificationService = NotificationService();
  await notificationService.init();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    notificationService.showNotification(message);
  });

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ContactViewModel()),
      ],
      child: const HereBro(),
    ),
  );
}

class HereBro extends StatelessWidget {
  const HereBro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HereBro',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
