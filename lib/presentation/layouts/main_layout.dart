import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/organisms/aerisys_bottom_nav_bar.dart';
import '../../core/routes/app_routes.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the active item based on the current URI
    final String location = GoRouterState.of(context).matchedLocation;
    
    NavItemType? activeItem;
    if (location == AppRoutes.home) {
      activeItem = NavItemType.home;
    } else if (location == AppRoutes.appareils || location == AppRoutes.droneList) {
      activeItem = NavItemType.droneList;
    } else if (location == AppRoutes.contact) {
      activeItem = NavItemType.contact;
    } else if (location == AppRoutes.camera) {
      // Assuming a camera route exists or matches something
      activeItem = NavItemType.camera;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Content
          child,
          
          // Persistent Floating Bottom Nav Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: AerisysBottomNavBar(activeItem: activeItem),
          ),
        ],
      ),
    );
  }
}
