import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/reminder/data/reminder_local_service.dart';
import 'features/reminder/presentation/providers/reminder_provider.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ReminderLocalService>(
          create: (_) => ReminderLocalService(),
        ),
        ChangeNotifierProxyProvider<ReminderLocalService, ReminderProvider>(
          create: (context) => ReminderProvider(
            localService: context.read<ReminderLocalService>(),
          ),
          update: (context, service, previous) =>
              previous ?? ReminderProvider(localService: service),
        ),
      ],
      child: MaterialApp(
        title: 'Contact Lens Reminder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: RouteNames.home,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
