import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:presentation_master_2/store.dart' as store;

import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';
import 'package:presentation_master_2/wifi.dart';
import 'package:presentation_master_2/home.dart';
import 'package:presentation_master_2/help.dart';




void navigateToAvailablePresenter(BuildContext context, {bool preferMinimalPresenter = false}) {
  if (currentPresentation == null || ( currentPresentation?[store.presentationNotesKey] ?? "" ) == "") {
    if (serverIP == null) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => const WifiSetup(),
      ));
      return;
    }
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const MinimalPresenter(),
    ));
    return;
  }
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => preferMinimalPresenter
    ? const MinimalPresenter()
    : const NotePresenter(),
  ));
}


bool _showClosingDialog(BuildContext context, {bool navigateToNoteEditor = false}) {
  showBooleanDialog(
    context: context,
    title: navigateToNoteEditor ? "Exit to edit speaker notes?" : "End presentation?",
    onYes: () {
      Navigator.pop(context);
      if (navigateToNoteEditor) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Home(editing: true),
        ));
      }
    },
  );
  return false;
}




class NotePresenter extends StatefulWidget {
  const NotePresenter({super.key});

  @override
  State<NotePresenter> createState() => _NotePresenterState();
}

class _NotePresenterState extends State<NotePresenter> {

  bool _connected = false;
  Timer? _connectionStatusTimer;
  bool _wasCancelled = false;
  bool _mouseReady = true;

  Timer _visibleTimer = Timer(const Duration(), () {});
  bool _isTimerActive = false;
  int _timerMinutes = 0;
  int _timerSeconds = 0;

  double _notesTextScaleFactor = 1;

  bool _isMousePadExpanded = false;


  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();

    _timerMinutes = currentPresentation?[store.presentationMinutesKey];
    _isTimerActive = _timerMinutes > 0;

    _visibleTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_isTimerActive) {
        setState(() {
          if (_timerSeconds <= 0) {
            if (_timerMinutes <= 0) {
              Vibrate.feedback(FeedbackType.warning);
              _visibleTimer.cancel();
              return;
            }
            _timerSeconds = 59;
            _timerMinutes--;
            return;
          }
          _timerSeconds--;
        });
      }
    });

    _connectionStatusTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(() {
        _isMousePadExpanded = serverIP != null && _isMousePadExpanded;
        if (_connected != ( serverIP != null )) {
          _wasCancelled = false;
        }
        _connected = serverIP != null;
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();
    _visibleTimer.cancel();
    _connectionStatusTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async => _showClosingDialog(context),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorScheme.background,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: colorScheme.background,
          ),
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: () => _showClosingDialog(context, navigateToNoteEditor: true),
                child: Container(
                  height: screenHeight(context),
                  padding: const EdgeInsets.all(16).copyWith(top: 32),
                  child: Markdown(
                    styleSheet: MarkdownStyleSheet(
                      textScaleFactor: _notesTextScaleFactor,
                      blockSpacing: 16,
                      p: MainText.textStyle.copyWith(fontSize: 22),
                      pPadding: const EdgeInsets.only(bottom: 10),
                      h1: MainText.textStyle.copyWith(fontSize: 40),
                      h1Padding: const EdgeInsets.only(bottom: 20),
                      h2: MainText.textStyle.copyWith(fontSize: 36),
                      h2Padding: const EdgeInsets.only(bottom: 12),
                      h3: MainText.textStyle.copyWith(fontSize: 32),
                      h3Padding: const EdgeInsets.only(bottom: 16),
                      h4: MainText.textStyle.copyWith(fontSize: 30),
                      h4Padding: const EdgeInsets.only(bottom: 15),
                      h5: MainText.textStyle.copyWith(fontSize: 28),
                      h5Padding: const EdgeInsets.only(bottom: 14),
                      h6: MainText.textStyle.copyWith(fontSize: 24),
                      h6Padding: const EdgeInsets.only(bottom: 12),
                      code: MainText.textStyle.copyWith(fontFamily: "IBM Plex Mono"),
                    ),
                    data: currentPresentation?[store.presentationNotesKey] ?? "Error loading notes. Please contact the developer.",
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: appDefaultCurve,
                bottom: serverIP == null ? -256 : 0,
                width: screenWidth(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => showBooleanDialog(
                        context: context,
                        title: "Move your PC's cursor by using this field like a touchpad.",
                      ),
                      onPanUpdate: (details) {
                        if (_mouseReady) {
                          _mouseReady = false;
                          control(
                            context: context,
                            action: ControlAction.mousemove,
                            mouseXY: [
                              ( details.delta.dx / screenWidth(context) * 1920 ).toInt(),
                              ( details.delta.dy / ( screenWidth(context) * 9/16 ) * 1080 ).toInt(),
                            ],
                          );
                          Timer(const Duration(milliseconds: 0), () => _mouseReady = true);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: appDefaultCurve,
                        height: _isMousePadExpanded ? ( screenWidth(context) - 2 * 16 ) * 9/16 : 0,
                        margin: _isMousePadExpanded
                        ? const EdgeInsets.all(8).copyWith(top: 0, bottom: 16)
                        : EdgeInsets.only(left: 8 + ( screenWidth(context) - 16 ) * 0.2, right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme.surface,
                        ),
                        alignment: Alignment.center,
                        child: _isMousePadExpanded
                        ? Icon(
                          Icons.mouse_outlined,
                          size: 32,
                          color: colorScheme.onSurface.withOpacity(0.25),
                        )
                        : const SizedBox(),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInCubic,
                      height: _connected || _wasCancelled ? 0 : 64,
                      child: SingleChildScrollView(
                        child: Container(
                          height: 64,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: AppAnimatedSwitcher(
                                      value: serverIP != null,
                                      trueChild: const Icon(
                                        Icons.check_outlined,
                                        color: Colors.green,
                                      ),
                                      falseChild: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colorScheme.error,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  AppAnimatedSwitcher(
                                    value: serverIP != null,
                                    trueChild: SmallLabel("Connected"),
                                    falseChild: GestureDetector(
                                      onTap: () => Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => const WifiSetup(),
                                      )),
                                      child: SmallLabel("Connecting..."),
                                    ),
                                  ),
                                ],
                              ),
                              AppAnimatedSwitcher(
                                value: serverIP != null,
                                trueChild: const SizedBox(),
                                falseChild: AppTextButton(
                                  onPressed: () => setState(() {
                                    _wasCancelled = true;
                                  }),
                                  mini: true,
                                  onBackground: true,
                                  label: "Cancel",
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ),
                    Divider(
                      height: 0,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 64,
                      child: Row(
                        children: [
                          hasPro && _isTimerActive
                          ? SizedBox(
                            width: 64,
                            height: 64,
                            child: TextButton(
                              onPressed: () => _showClosingDialog(context),
                              child: Icon(
                                Icons.close_outlined,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          )
                          : Expanded(
                            child: SizedBox(
                              height: 64,
                              child: TextButton(
                                onPressed: () => _showClosingDialog(context),
                                child: Icon(
                                  Icons.close_outlined,
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              VerticalDivider(
                                width: 1,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                              TextButton(
                                onPressed: () => setState(() => _notesTextScaleFactor /= 1.1),
                                child: SizedBox(
                                  width: serverIP != null || ( hasPro && _isTimerActive ) ? 64 : screenWidth(context) / 3,
                                  height: 64,
                                  child: Icon(
                                    Icons.text_decrease_outlined,
                                    color: colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 1,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                              TextButton(
                                onPressed: () => setState(() => _notesTextScaleFactor *= 1.1),
                                child: SizedBox(
                                  width: serverIP != null || ( hasPro && _isTimerActive ) ? 64 : screenWidth(context) / 3,
                                  height: 64,
                                  child: Icon(
                                    Icons.text_increase_outlined,
                                    color: colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 1,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ],
                          ),
                          Builder(
                            builder: (context) {

                              final Widget child = TextButton(
                                onPressed: () {
                                  if (serverIP == null) {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const WifiSetup(),
                                    ));
                                    return;
                                  }
                                  setState(() => _isMousePadExpanded = !_isMousePadExpanded);
                                },
                                style: serverIP != null
                                ? null
                                : ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  splashFactory: NoSplash.splashFactory,
                                  enableFeedback: false,
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  switchInCurve: Curves.easeInOut,
                                  switchOutCurve: Curves.easeInOut,
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    serverIP == null
                                    ? Icons.wifi_off_outlined
                                    : (
                                      _isMousePadExpanded
                                      ? Icons.expand_more_outlined
                                      : Icons.mouse_outlined
                                    ),
                                    key: ValueKey<bool>(_isMousePadExpanded || serverIP != null),
                                    color: colorScheme.onSurface.withOpacity(serverIP != null ? 0.5 : 0.25),
                                  ),
                                ),
                              );

                              return hasPro && _isTimerActive
                              ? SizedBox(
                                width: 64,
                                height: 64,
                                child: child,
                              )
                              : Expanded(
                                child: SizedBox(
                                  height: 64,
                                  child: child,
                                ),
                              );
                            }
                          ),
                          if (hasPro && _isTimerActive) VerticalDivider(
                            width: 1,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                          if (hasPro && _isTimerActive) Expanded(
                            child: Container(
                              height: 64,
                              decoration: BoxDecoration(
                                color: colorScheme.background,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${_timerMinutes < 10 ? "0$_timerMinutes" : _timerMinutes}:${_timerSeconds < 10 ? "0$_timerSeconds" : _timerSeconds}",
                                style: GoogleFonts.lexend(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: appDefaultCurve,
                      height: _isMousePadExpanded ? 192 : 256,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => control(context: context, action: ControlAction.back),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(const RoundedRectangleBorder()),
                              fixedSize: MaterialStateProperty.all(Size(screenWidth(context) / 2 - 0.5, 256)),
                            ),
                            child: hasPro
                            ? Icon(
                              Icons.arrow_back_ios_new_outlined,
                              size: 32,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            )
                            : Opacity(
                              opacity: 0.5,
                              child: ButtonLabel("Previous\nSlide"),
                            ),
                          ),
                          VerticalDivider(
                            width: 1,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                          TextButton(
                            onPressed: () => control(context: context, action: ControlAction.forward),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(const RoundedRectangleBorder()),
                              fixedSize: MaterialStateProperty.all(Size(screenWidth(context) / 2 - 0.5, 256)),
                            ),
                            child: hasPro
                            ? Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 32,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            )
                            : Opacity(
                              opacity: 0.5,
                              child: ButtonLabel("Next\nSlide"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class MinimalPresenter extends StatefulWidget {
  const MinimalPresenter({super.key});

  @override
  State<MinimalPresenter> createState() => _MinimalPresenterState();
}

class _MinimalPresenterState extends State<MinimalPresenter> {

  bool _leftHanded = false;

  Timer _timer = Timer(const Duration(), () {});
  bool _isTimerActive = false;
  int _timerMinutes = 0;
  int _timerSeconds = 0;

  bool _mouseReady = true;


  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();

    _timerMinutes = currentPresentation?[store.presentationMinutesKey] ?? 0;
    _isTimerActive = _timerMinutes > 0;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(() {
        if (_isTimerActive) {
          if (_timerSeconds <= 0) {
            if (_timerMinutes <= 0) {
              Vibrate.feedback(FeedbackType.warning);
              _timer.cancel();
              return;
            }
            _timerSeconds = 59;
            _timerMinutes--;
            return;
          }
          _timerSeconds--;
        }
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async => _showClosingDialog(context),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorScheme.background,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: colorScheme.background,
          ),
        ),
        body: SafeArea(
          child: AppAnimatedSwitcher(
            fading: true,
            milliseconds: 200,
            switchInCurve: appDefaultCurve,
            switchOutCurve: appDefaultCurve,
            value: serverIP == null,
            trueChild: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 64),
                  // TODO: Navigate to WifiSetup?
                  SmallHeading("Reconnecting..."),
                  const SizedBox(height: 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppTextButton(
                        onPressed: () => Navigator.pop(context),
                        onBackground: true,
                        label: "Exit presentation",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            falseChild: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: _leftHanded ? Alignment.bottomRight : Alignment.bottomLeft,
                    children: [
                      Builder(
                        builder: (context) {
                          final Widget previousButton = TextButton(
                            onPressed: () => control(context: context, action: ControlAction.back),
                            child: SizedBox(
                              width: 128,
                              child: Opacity(
                                opacity: 0.75,
                                child: ButtonLabel("Previous"),
                              ),
                            ),
                          );
          
                          final Widget nextButton = Expanded(
                            child: TextButton(
                              onPressed: () => control(context: context, action: ControlAction.forward),
                              child: Opacity(
                                opacity: 0.75,
                                child: ButtonLabel("Next\nSlide"),
                              ),
                            ),
                          );
          
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _leftHanded ? nextButton : previousButton,
                              VerticalDivider(
                                width: 1,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                              _leftHanded ? previousButton : nextButton,
                            ],
                          );
                        }
                      ),
                      TextButton(
                        onPressed: () => setState(() => _leftHanded = !_leftHanded),
                        child: Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: colorScheme.onBackground.withOpacity(0.5),
                              ),
                            ),
                          ),
                          child: Icon(
                            Icons.swap_horiz_outlined,
                            size: 32,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                GestureDetector(
                  onTap: () => showBooleanDialog(
                    context: context,
                    title: "Move your PC's cursor by using this field like a touchpad.",
                  ),
                  onPanUpdate: (details) {
                    if (_mouseReady) {
                      _mouseReady = false;
                      control(
                        context: context,
                        action: ControlAction.mousemove,
                        mouseXY: [
                          ( details.delta.dx / screenWidth(context) * 1920 ).toInt(),
                          ( details.delta.dy / ( screenWidth(context) * 9/16 ) * 1080 ).toInt(),
                        ],
                      );
                      Timer(const Duration(milliseconds: 0), () => _mouseReady = true);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: appDefaultCurve,
                    height: screenWidth(context) * 9/16,
                    color: colorScheme.surface,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.mouse_outlined,
                      size: 32,
                      color: colorScheme.onSurface.withOpacity(0.25),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                SizedBox(
                  height: 128,
                  child: Builder(
                    builder: (context) {
          
                      final Widget closeButton = SizedBox(
                        width: 128,
                        height: 128,
                        child: TextButton(
                          onPressed: () => _showClosingDialog(context),
                          child: Icon(
                            Icons.close_outlined,
                            size: 32,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      );
          
                      final Widget otherButton = Expanded(
                        child: Container(
                          height: 128,
                          alignment: Alignment.center,
                          child: hasPro && _isTimerActive
                          ? Text(
                            "${_timerMinutes < 10 ? "0$_timerMinutes" : _timerMinutes}:${_timerSeconds < 10 ? "0$_timerSeconds" : _timerSeconds}",
                            style: GoogleFonts.lexend(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground.withOpacity(0.75),
                            ),
                          )
                          : TextButton(
                            onPressed: () => _showClosingDialog(context, navigateToNoteEditor: true),
                            child: Opacity(
                              opacity: 0.25,
                              child: SizedBox.expand(
                                child: Center(
                                  child: ButtonLabel("Add speaker notes"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
          
                      return Row(
                        children: [
                          _leftHanded ? otherButton : closeButton,
                          VerticalDivider(
                            width: 1,
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                          _leftHanded ? closeButton : otherButton,
                        ],
                      );
                    }
                  ),
                ),
                if (!hasPro && _isTimerActive) Divider(
                  height: 0,
                  thickness: 1,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                if (!hasPro && _isTimerActive) SizedBox(
                  height: 96,
                  child: TextButton(
                    onPressed: () => _showClosingDialog(context, navigateToNoteEditor: true),
                    child: Opacity(
                      opacity: 0.25,
                      child: SizedBox.expand(
                        child: Center(
                          child: ButtonLabel("Add speaker notes"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}