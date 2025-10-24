// ignore_for_file: deprecated_member_use
// TODO: Splash screen icon

import 'dart:io';

import "package:flutter/services.dart";
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import "package:logger/logger.dart";
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:presentation_master_2/design.dart';

import 'package:presentation_master_2/store.dart' as store;
import 'package:presentation_master_2/home.dart';




final monetization = Platform.isAndroid;

final logger = Logger(
  printer: PrettyPrinter(
    noBoxingByDefault: true,
    methodCount: 0,
  ),
);

final colorScheme = ColorScheme(
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

final TooltipController onboardingTooltipController = TooltipController();
bool onboarding = true;

store.Presentations? globalPresentations;
Map<String, dynamic>? currentPresentation;
bool hasPro = false;
String? serverIP;

double topPadding(BuildContext context) => MediaQuery.of(context).padding.top;
double bottomPadding(BuildContext context) => MediaQuery.of(context).padding.bottom;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height - topPadding(context) - bottomPadding(context);
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (monetization) {
    store.moneyPrinter.purchaseStream.listen(
      (details) async {
        if (
          details.last.pendingCompletePurchase ||
          details.last.status == PurchaseStatus.purchased ||
          details.last.status == PurchaseStatus.restored
        ) {
          if (details.last.pendingCompletePurchase) {
            store.moneyPrinter.completePurchase(details.first);
          }
          store.changePro(true);
        }
      },
    );
    await store.moneyPrinter.restorePurchases();
  }
  runApp(const PresentationMaster2());
}




class PresentationMaster2 extends StatefulWidget {
  const PresentationMaster2({Key? key}) : super(key: key);

  @override
  State<PresentationMaster2> createState() => _PresentationMaster2State();

  static void setAppState(BuildContext context, [Function()? function]) {
    _PresentationMaster2State? ancestorState = context.findAncestorStateOfType<_PresentationMaster2State>();
    if (ancestorState == null) {
      logger.e("ancestorState == null in setAppState()");
      return;
    }
    // ignore: invalid_use_of_protected_member
    ancestorState.setState(function ?? () {});
  }
}

class _PresentationMaster2State extends State<PresentationMaster2> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Builder(
      builder: (context) => MaterialApp(
        title: "Presentation Master 2",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: colorScheme.background,
          iconTheme: IconThemeData(
            color: colorScheme.onSurface,
            size: 24,
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              iconColor: WidgetStateProperty.all(colorScheme.onSurface),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(const RoundedRectangleBorder()),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              backgroundColor: WidgetStateProperty.all(colorScheme.background),
              overlayColor: WidgetStateProperty.all(colorScheme.onSurface.withOpacity(0.1)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.zero,
            hintStyle: MainText.textStyle.copyWith(
              color: MainText.textStyle.color?.withOpacity(0.5),
            ),
          ),
          appBarTheme: const AppBarTheme(
            toolbarHeight: 0,
          ),
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: const Home(),
      ),
    );
  }
}