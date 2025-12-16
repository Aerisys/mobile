import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _lastMessage = 'Aucun message reçu';
  StreamSubscription<RemoteMessage>? _subscription;

  @override
  void initState() {
    super.initState();

    final notificationService = Provider.of<NotificationService>(
      context,
      listen: false,
    );

    _subscription = notificationService.messageStream.listen((
      RemoteMessage message,
    ) {
      setState(() {
        _lastMessage = message.notification != null
            ? '🔔 ${message.notification?.title}\n${message.notification?.body}'
            : '📦 ${message.data}';
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _lastMessage,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
