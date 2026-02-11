import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/admin_management_screen.dart';
import '../providers/main_app_ui_provider.dart';

class MainApp extends StatelessWidget {
  final VoidCallback onLogout;

  const MainApp({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const DashboardScreen(),
      const ReportsScreen(),
    ];

    return ChangeNotifierProvider(
      create: (_) => MainAppUIProvider(),
      child: Consumer<MainAppUIProvider>(
        builder: (context, ui, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Fitness Arena'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  tooltip: 'Manage Admins',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminManagementScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onLogout();
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            body: screens[ui.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Members',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assessment),
                  label: 'Reports',
                ),
              ],
              currentIndex: ui.selectedIndex,
              selectedItemColor: const Color(0xFF6B5DFF),
              unselectedItemColor: Colors.grey[400],
              backgroundColor: Colors.white,
              elevation: 8,
              type: BottomNavigationBarType.fixed,
              onTap: ui.setSelectedIndex,
            ),
          );
        },
      ),
    );
  }
}
