/*  TODO:
      - Eliminate every presenter_2 after making safety copy of project
      - Make vibration less strong
      - Check if WiFi is on
*/

import "package:flutter/services.dart";
import 'package:flutter/material.dart';

import "package:logger/logger.dart";

import 'package:presentation_master_2/store.dart' as store;
import 'package:presentation_master_2/home.dart';




ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.white,
  onPrimary: Colors.black,
  secondary: Colors.grey.shade900,
  onSecondary: Colors.white,
  error: Colors.red,
  onError: Colors.white,
  background: Colors.black,
  onBackground: Colors.white,
  surface: Colors.grey.shade900,
  onSurface: Colors.white,
);

const appDefaultCurve = Cubic(.4, 0, .2, 1);
final logger = Logger(printer: PrettyPrinter());

store.Presentations? globalPresentations;
bool hasUltra = false;
String? serverIP;

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}




class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setAppState(BuildContext context, [Function()? function]) {
    _MyAppState? _ancestorState = context.findAncestorStateOfType<_MyAppState>();
    // ignore: invalid_use_of_protected_member
    _ancestorState?.setState(function ?? () {});
  }
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Builder(builder: (context) {
      ThemeData materialAppTheme = ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.background,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            iconColor: MaterialStateProperty.all(colorScheme.onSurface),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            backgroundColor: MaterialStateProperty.all(colorScheme.background),
            overlayColor: MaterialStateProperty.all(colorScheme.onSurface.withOpacity(0.1)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.zero,
        ),
        dividerTheme: const DividerThemeData(
          space: 0,
        ),
        appBarTheme: AppBarTheme(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorScheme.background,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: colorScheme.background,
          ),
        )
      );

      return MaterialApp(
        title: "Presentation Master 2",
        theme: materialAppTheme,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: Home(),
      );
    });
  }
}