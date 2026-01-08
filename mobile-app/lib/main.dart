import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:smart_safety_welfare/gs-screens/get_started_screen.dart';
import 'package:smart_safety_welfare/dashboard/dashboard_screen.dart';
import 'package:smart_safety_welfare/services/locale_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _storage = const FlutterSecureStorage();
  final LocaleService _localeService = LocaleService();

  Future<bool> _isLoggedIn() async {
    String? loggedIn = await _storage.read(key: 'isLoggedIn');
    return loggedIn == 'true';
  }

  @override
  void initState() {
    super.initState();
    _localeService.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocaleService>.value(
      value: _localeService,
      child: Consumer<LocaleService>(
        builder: (context, localeService, child) {
          return FutureBuilder<bool>(
            future: _isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MaterialApp(
                  home: const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              final isLoggedIn = snapshot.data ?? false;
              final Widget homeWidget = isLoggedIn ? const DashboardScreen() : const GetStartedScreen();

              return MaterialApp(
                title: 'Smart Safety Welfare',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFFDD671F), // orange brand
                  ),
                  useMaterial3: true,
                  scaffoldBackgroundColor: Colors.white,
                ),
                home: homeWidget,
              );
            },
          );
        },
      ),
    );
  }
}
