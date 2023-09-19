import 'package:flutter/material.dart';
import 'package:google_map_tracker/pages/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_map_tracker/controllers/postos_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostosController()),
      ],
      child:  MyApp(homeScreen: AuthScreen()),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Widget? homeScreen;
  const MyApp({Key? key, this.homeScreen}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: this.widget.homeScreen,
    );
  }
}
