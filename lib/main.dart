import 'package:ev_spot_flutter/components/my_theme_component.dart';
import 'package:ev_spot_flutter/screens/splash_screen.dart';
import 'package:ev_spot_flutter/store/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

AppStore appStore = AppStore();
SharedPreferences? prefs;

late String darkMapStyle;
late String lightMapStyle;

void main() async {
  await Supabase.initialize(
    url: 'https://xtbsahcvcgnfeognmjxi.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh0YnNhaGN2Y2duZmVvZ25tanhpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUyNDkwOTUsImV4cCI6MjAzMDgyNTA5NX0.zDyihSELdoGpKb22WmhEaie1WbB3wnqPuSajhqqT9VI',
  );

  /// It is used to initialized the app before the use of widgets.
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));

  prefs = await SharedPreferences.getInstance();
  appStore.changeTheme(prefs!.getBool('themeStatus') ?? false);

  darkMapStyle = await rootBundle.loadString('assets/mapStyles/dark.json');
  lightMapStyle = await rootBundle.loadString('assets/mapStyles/light.json');

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: MyTheme.lightTheme,
          themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: MyTheme.darkTheme,
          home: SplashScreen(),
        );
      },
    );
  }
}
