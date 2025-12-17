import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aerisys Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildMenuButton(
              context,
              title: 'Drone Control',
              icon: Icons.airplanemode_active,
              color: Colors.blue,
              onTap: () => context.push(AppRoutes.droneList),
            ),
            _buildMenuButton(
              context,
              title: 'Location / Map',
              icon: Icons.map,
              color: Colors.green,
              onTap: () => context.push(AppRoutes.location),
            ),
            _buildMenuButton(
              context,
              title: 'Settings',
              icon: Icons.settings,
              color: Colors.grey,
              onTap: () => context.push(AppRoutes.settings),
            ),
            _buildMenuButton(
              context,
              title: 'Contacts',
              icon: Icons.contacts,
              color: Colors.orange,
              onTap: () => context.push(AppRoutes.contact),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}