import 'package:flutter/material.dart';
import '../features/reminder/presentation/screens/reminder_home_screen.dart';
import 'route_names.dart';

/// App route generation
class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const ReminderHomeScreen(),
        );
      // Setup screen will be implemented later
      // case RouteNames.setup:
      //   return MaterialPageRoute(
      //     builder: (_) => const ReminderSetupScreen(),
      //   );
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
