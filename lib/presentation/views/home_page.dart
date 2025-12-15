import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../view_model/auth_view_model.dart'; // Vérifie le chemin

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
              context.push('/settings');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Bienvenue sur HereBro !"),
      ),
    );
  }
}