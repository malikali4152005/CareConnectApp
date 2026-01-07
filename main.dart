import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.initDB();
  runApp(CareConnectApp());
}

/// Global notifier for theme changes
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class CareConnectApp extends StatefulWidget {
  @override
  State<CareConnectApp> createState() => _CareConnectAppState();
}

class _CareConnectAppState extends State<CareConnectApp> {
  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('darkMode') ?? false;
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'CareConnect',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
          ),
          themeMode: currentMode,
          initialRoute: '/',
          routes: {
            '/': (ctx) => FutureBuilder<bool>(
                  future: _isLoggedIn(),
                  builder: (ctx, snap) {
                    if (!snap.hasData)
                      return Scaffold(
                          body: Center(child: CircularProgressIndicator()));
                    return snap.data! ? DashboardScreen() : LoginScreen();
                  },
                ),
            '/dashboard': (ctx) => DashboardScreen(),
          },
        );
      },
    );
  }

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
