import 'package:flutter/material.dart';

/// A wrapper widget for shell routes that provides common layout structure
/// This can be used to add navigation bars, side menus, or other shared UI elements
class ShellRouteWrapper extends StatelessWidget {
  final Widget child;

  const ShellRouteWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You can add common app bar, drawer, bottom navigation here
      // For now, just return the child
      body: child,
      
      // Example: Add a common app bar
      // appBar: AppBar(
      //   title: const Text('Gigafaucet'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout),
      //       onPressed: () {
      //         // Handle logout
      //       },
      //     ),
      //   ],
      // ),
      
      // Example: Add bottom navigation
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.local_offer),
      //       label: 'Offers',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}