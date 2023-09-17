import 'package:flutter/material.dart';
import 'package:google_map_tracker/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:google_map_tracker/controllers/postos_controller.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostosController()),
      ],
      child: const MyApp(homeScreen: HomePage()),
    ),
  );
}


class MyApp extends StatefulWidget {
  final Widget? homeScreen;
  const MyApp({Key? key, this.homeScreen}) : super(key : key);

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

