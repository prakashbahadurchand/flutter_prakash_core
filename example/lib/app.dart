import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

import 'features/ads/presentation/screens/ads_screen.dart';
import 'features/device/presentation/screens/core_screen.dart';
import 'features/maps/presentation/screens/maps_screen.dart';
import 'features/media/presentation/screens/media_screen.dart';
import 'features/posts/presentation/screens/network_screen.dart';
import 'features/ui/presentation/screens/ui_screen.dart';

/// Application composition root for the Flutter side: theme + navigation.
class FlutterPrakashExample extends StatelessWidget {
  const FlutterPrakashExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Prakash Engine',
      debugShowCheckedModeBanner: false,
      theme: AppThemeBuilder.buildLightTheme(),
      darkTheme: AppThemeBuilder.buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _tabs = <Widget>[
    CoreScreen(),
    NetworkScreen(),
    MediaScreen(),
    MapsScreen(),
    AdsScreen(),
    UiScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _tabs[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Core',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_outlined),
            selectedIcon: Icon(Icons.cloud),
            label: 'Network',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_outline),
            selectedIcon: Icon(Icons.play_circle),
            label: 'Media',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Maps',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Ads',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            selectedIcon: Icon(Icons.palette),
            label: 'UI',
          ),
        ],
      ),
    );
  }
}