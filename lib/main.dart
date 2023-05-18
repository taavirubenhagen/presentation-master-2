/*  TODO:
      - MaterialButton -> TextButton
*/

import "package:flutter/services.dart";
import 'package:flutter/material.dart';

import "package:logger/logger.dart";

import 'package:presenter_2/home.dart';

// GLOBAL CONSTANTS OR SEMICONSTANTS

final logger = Logger(printer: PrettyPrinter());

ColorScheme appLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color.fromRGBO(0, 0, 0, 1),
  onPrimary: Colors.white,
  secondary: const Color.fromRGBO(0, 0, 0, 1),
  onSecondary: Colors.white,
  error: Colors.red.shade700,
  onError: Colors.white,
  background: Colors.white,
  onBackground: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
);
ColorScheme appDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.black,
  onPrimary: Colors.white.withOpacity(0.8),
  secondary: Colors.black,
  onSecondary: Colors.white,
  error: Colors.red,
  onError: Colors.white,
  background: Colors.black,
  onBackground: Colors.white.withOpacity(0.8),
  surface: Colors.grey.shade900,
  onSurface: Colors.white,
);

// GLOBAL VARIABLES

ColorScheme colorScheme = appLightColorScheme;

// GLOBAL FUNCTIONS

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

  // TODO: R?
  static void setAppState(BuildContext context, [Function()? function]) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    colorScheme = MediaQuery.of(context).platformBrightness == Brightness.dark && false
        ? appDarkColorScheme
        : appLightColorScheme;
    // ignore: invalid_use_of_protected_member
    state.setState(function ?? () {});
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final window = WidgetsBinding.instance.window;

    window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      colorScheme = window.platformBrightness == Brightness.dark
          ? appDarkColorScheme
          : appLightColorScheme;
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Builder(builder: (context) {
      ThemeData materialAppTheme = ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme.brightness == Brightness.dark
            ? appDarkColorScheme
            : colorScheme,
        scaffoldBackgroundColor: colorScheme.background,
        iconTheme: IconThemeData(
          color: colorScheme.onBackground,
          size: 24,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            overlayColor: MaterialStateProperty.all(colorScheme.primary.withOpacity(0.05)),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: const CircleBorder(),
          sizeConstraints: const BoxConstraints(
            maxWidth: 72,
            maxHeight: 72,
            minWidth: 72,
            minHeight: 72,
          ),
          backgroundColor: colorScheme.primary,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.zero,
        ),
        dividerTheme: const DividerThemeData(
          space: 0,
        )
      );

      return MaterialApp(
        title: "Presentation Master",
        theme: materialAppTheme,
        themeMode: colorScheme.brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: Home(),
      );
    });
  }
}