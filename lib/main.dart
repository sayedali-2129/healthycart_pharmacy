import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthycart_pharmacy/app.dart';
import 'package:healthycart_pharmacy/core/di/injection.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependancy();
  runApp(const App());
}
 