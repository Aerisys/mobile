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
    // matchedLocation gets the exact string from app_routes.dart (e.g. '/drone' or '/appareils')
    final String location = GoRouterState.of(context).matchedLocation;
    
    NavItemType? activeItem;
    
    // 1. If on Appareils Choice Page OR Dashboard -> Highlight the House Icon
    if (location == AppRoutes.appareils || location == AppRoutes.home) {
      activeItem = NavItemType.accueil; 
    } 
    // 2. If on the Drone List -> Highlight the Drone Icon
    else if (location == AppRoutes.droneList) {
      activeItem = NavItemType.droneList;
    } 
    // 3. If on Contact -> Highlight Profile
    else if (location == AppRoutes.contact) {
      activeItem = NavItemType.contact;
    } 
    // 4. If on Camera -> Highlight Camera
    else if (location == AppRoutes.camera) {
      activeItem = NavItemType.camera;
    }

    return Scaffold(
      extendBody: true, 
      body: child, 
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16.0),
          child: AerisysBottomNavBar(activeItem: activeItem),
        ),
      ),
    );
  }
}