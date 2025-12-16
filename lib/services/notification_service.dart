import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final BehaviorSubject<RemoteMessage> messageStream =
      BehaviorSubject<RemoteMessage>();

  void handleMessage(RemoteMessage message) {
    messageStream.add(message);
  }

  void dispose() {
    messageStream.close();
  }
}
