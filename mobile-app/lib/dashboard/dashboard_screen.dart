import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'profile_info.dart';
import 'change_password.dart';
import '../main.dart';
import '../services/locale_service.dart';
import 'sos_tab_screen.dart';
import 'find_person_tab_screen.dart';
import 'relief_tab_screen.dart';

const Color customOrange = Color(0xFFDD671F); // Smart Safety Welfare brand color

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _storage = const FlutterSecureStorage();
  int _selectedIndex = 0;

  Future<void> _logout(BuildContext context) async {
    await _storage.deleteAll();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false,
      );
    }
  }

  void _handleMenuSelection(String choice, BuildContext context) {
    final localeService = Provider.of<LocaleService>(context, listen: false);
    final t = (String key) => LocaleService.translate(key, localeService.locale.languageCode);
    
    if (choice == t('profile_info')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileInfoScreen()),
      );
    } else if (choice == t('change_password')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
      );
    } else if (choice == t('logout')) {
      _logout(context);
    }
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  List<String> _getScreenTitles(BuildContext context) {
    return [
      'SOS',
      'Find Person',
      'Relief',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const SOSTabScreen(),
      const FindPersonTabScreen(),
      const ReliefTabScreen(),
    ];

    return Consumer<LocaleService>(
      builder: (context, localeService, child) {
        final t = (String key) => LocaleService.translate(key, localeService.locale.languageCode);
        final screenTitles = _getScreenTitles(context);
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              screenTitles[_selectedIndex],
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: customOrange,
            automaticallyImplyLeading: false,
            actions: [
              PopupMenuButton<String>(
                onSelected: (choice) => _handleMenuSelection(choice, context),
                icon: const Icon(Icons.person, color: Colors.white),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(value: t('profile_info'), child: Text(t('profile_info'))),
                  PopupMenuItem<String>(value: t('change_password'), child: Text(t('change_password'))),
                  PopupMenuItem<String>(value: t('logout'), child: Text(t('logout'))),
                ],
              ),
            ],
          ),
          body: screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.warning),
                label: 'SOS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_search),
                label: 'Find Person',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.volunteer_activism),
                label: 'Relief',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: customOrange,
            onTap: _onTabSelected,
            type: BottomNavigationBarType.fixed,
          ),
        );
      },
    );
  }

}
