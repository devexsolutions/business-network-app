import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(AppConstants.primaryColorValue),
        unselectedItemColor: const Color(AppConstants.textLightValue),
        currentIndex: currentIndex,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        onTap: (index) {
          switch (index) {
            case 0:
              if (currentIndex != 0) context.go('/home');
              break;
            case 1:
              if (currentIndex != 1) context.go('/network');
              break;
            case 2:
              if (currentIndex != 2) context.go('/events');
              break;
            case 3:
              if (currentIndex != 3) context.go('/business');
              break;
            case 4:
              if (currentIndex != 4) context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Red',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined),
            activeIcon: Icon(Icons.business_center),
            label: 'Negocios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
