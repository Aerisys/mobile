import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Paramètres",
            onPressed: () {
              context.push(AppRoutes.settings);
            },
          ),
        ],
      ),
      body: const Center(child: Text("Bienvenue sur HereBro !")),
    );
  }
}
