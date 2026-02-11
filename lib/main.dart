import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'services/auth_service.dart';
import 'services/month_management_service.dart';
import 'providers/member_provider.dart';
import 'providers/main_ui_provider.dart';
import 'theme/app_theme.dart';
import 'utils/app_logger.dart';
import 'main_app.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    AppLogger.info('Initializing application');
    await DatabaseService.initDatabase();
    await AuthService.initAuthDatabase();

    // Check and process month changes
    if (MonthManagementService.shouldProcessMonthChange()) {
      AppLogger.info('Processing automatic month change...');
      await MonthManagementService.processMonthChange();
      AppLogger.info('Month change processing completed');
    }

    AppLogger.info('Initialization completed successfully');
  } catch (e, stackTrace) {
    AppLogger.fatal('Failed to initialize application', e, stackTrace);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => MainUIProvider()),
      ],
      child: Consumer<MainUIProvider>(
        builder: (context, ui, _) {
          return ui.isLoggedIn
              ? MaterialApp(
                  title: 'Fitness Arena',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  home: MainApp(
                    onLogout: () => context.read<MainUIProvider>().logout(),
                  ),
                )
              : MaterialApp(
                  title: 'Fitness Arena',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  home: LoginScreen(
                    onLoginSuccess: () =>
                        context.read<MainUIProvider>().login(),
                  ),
                  routes: {
                    '/login': (_) => LoginScreen(
                      onLoginSuccess: () =>
                          context.read<MainUIProvider>().login(),
                    ),
                    '/signup': (_) => const SignupScreen(),
                  },
                );
        },
      ),
    );
  }
}
