import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pocketbase/src/ui/auth/login_ui.dart';
import 'package:flutter_pocketbase/src/ui/dashboard/dashboard_ui.dart';

import 'src/bloc/auth/auth_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => LoginBloc()..add(AppStarted()),
      child: MaterialApp(
        routes: {
          '/': (context) => const LoginPage(),
          '/dashboard': (context) => const DashboardUI(),
        },
      ),
    );
  }
}
