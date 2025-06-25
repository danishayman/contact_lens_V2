import 'package:flutter/material.dart';
import '../features/reminder/presentation/screens/reminder_home_screen.dart';
import '../features/reminder/presentation/screens/reminder_setup_screen.dart';
import '../features/reminder/presentation/screens/notification_test_screen.dart';
import '../features/reminder/domain/reminder_model.dart';
import 'route_names.dart';

/// App route generation
class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const ReminderHomeScreen(),
        );
      case RouteNames.setup:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ReminderSetupScreen(
            initialReminder: args?['reminder'] as ReminderModel?,
          ),
        );
      case RouteNames.notificationTest:
        return MaterialPageRoute(
          builder: (_) => const NotificationTestScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
