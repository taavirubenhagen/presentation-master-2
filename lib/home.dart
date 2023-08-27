import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:skeletons/skeletons.dart';

import 'package:presentation_master_2/store.dart' as store;
import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/wifi.dart';
import 'package:presentation_master_2/design.dart';
import 'package:presentation_master_2/help.dart';
import 'package:presentation_master_2/presenter.dart';




// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({super.key, this.editing = false});

  bool editing;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  bool _presentationsExpanded = false;
  String? _name;
  bool _isEditingTimer = false;


  void _changeEditingMode({bool wasTimerButtonPressed = false, bool allToFalse = false}) => setState(() {
    _presentationsExpanded = false;
    if (allToFalse) {
      widget.editing = false;
      _isEditingTimer = false;
      return;
    }
    if (!wasTimerButtonPressed) {
      widget.editing = !widget.editing;
      _isEditingTimer = false;
      return;
    }
    widget.editing = true;
    _isEditingTimer = !_isEditingTimer;
  });

  void _nudgeTimerMinutes({required bool decrease, int interval = 1}) async {
    currentPresentation = await store.mutatePresentation(
      oldPresentation: currentPresentation,
      timerMinutes: (() {
        int newMinutes = currentPresentation?[store.presentationMinutesKey] + ( decrease ? -interval : interval );
        if (newMinutes < 0) {
          return 0;
        }
        if (newMinutes > 99) {
          return 99;
        }
        return newMinutes;
      })(),
    );
    setState(() {});
  }


  @override
  void initState() {
    super.initState();

    (() async {
      hasPro = await store.accessProStatus() ?? await store.accessProStatus(toggle: true) ?? false;

      await store.accessPresentations();
      MyApp.setAppState(context, () => currentPresentation ??= globalPresentations?.first);
    })();
    connect(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.editing) {
          _changeEditingMode(allToFalse: true);
          return false;
        }
        showBooleanDialog(
          context: context,
          title: "Exit app?",
          onYes: () => SystemNavigator.pop(),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: widget.editing ? colorScheme.surface : colorScheme.background,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: colorScheme.surface,
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: screenWidth(context),
          height: 80,
          child: TextButton(
            onPressed: () => widget.editing
            ? hasPro
              ? launchUrlString(
                "https://www.markdownguide.org/cheat-sheet/",
                mode: LaunchMode.externalApplication,
              )
              : Navigator.push(context, MaterialPageRoute(
                builder: (context) => const GetProScreen(),
              ))
            : Navigator.push(context, MaterialPageRoute(
              builder: (context) => HelpCenter(presentationData: currentPresentation),
            )),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(const RoundedRectangleBorder()),
              backgroundColor: MaterialStateProperty.all(colorScheme.surface),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: widget.editing
              ? hasPro
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonLabel("How to format"),
                    const SizedBox(width: 8),
                    const Icon(Icons.open_in_new_outlined),
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonLabel("Timer & Formatting"),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_outlined),
                  ],
                )
              : ButtonLabel("Help Center"),
            ),
          ),
        ),
        body: Builder(
          builder: (BuildContext context) {
        
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: appDefaultCurve,
                    switchOutCurve: appDefaultCurve,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      key: ValueKey<bool>(widget.editing && _isEditingTimer),
                      width: screenWidth(context),
                      height: screenHeight(context),
                      child: widget.editing
                      ? AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        switchInCurve: appDefaultCurve,
                        switchOutCurve: appDefaultCurve,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: _isEditingTimer
                        ? Container(
                          padding: const EdgeInsets.all(16).copyWith(top: 16 + 80 + 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Skeleton(
                                isLoading: currentPresentation?[store.presentationNameKey] == null || currentPresentation?[store.presentationNotesKey] == null,
                                skeleton: SkeletonLine(
                                  style: SkeletonLineStyle(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(bottom: 16),
                                    width: screenWidth(context) * 0.8,
                                    height: 128,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: SizedBox(
                                  height: 128,
                                  child: HugeLabel(
                                    (
                                      currentPresentation?[store.presentationMinutesKey]
                                      ?? "Error loading speaker notes. This presentation does not seem to be initialized correctly. Please contact the developer."
                                    ).toString() + " min",
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  for (int i = 0; i <= 1; i++) Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1/1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: TextButton(
                                          onLongPress: () => _nudgeTimerMinutes(
                                            decrease: i < 1,
                                            interval: 10,
                                          ),
                                          onPressed: () => _nudgeTimerMinutes(decrease: i < 1),
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            )),
                                            backgroundColor: MaterialStateProperty.all(colorScheme.surface),
                                          ),
                                          child: Icon(
                                            [Icons.remove_outlined, Icons.add_outlined][i],
                                            size: 48,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16 + 16 + 80),
                          child: Skeleton(
                            isLoading: currentPresentation?[store.presentationNameKey] == null || currentPresentation?[store.presentationNotesKey] == null,
                            skeleton: Column(
                              children: [
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    padding: EdgeInsets.zero,
                                    width: screenWidth(context) * 0.8,
                                    height: 48,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                SkeletonParagraph(
                                  style: SkeletonParagraphStyle(
                                    padding: const EdgeInsets.only(top: 12 + 24 + 12),
                                    lines: 3,
                                    lineStyle: SkeletonLineStyle(
                                      height: 24,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    padding: const EdgeInsets.only(top: 12 + 24 + 12),
                                    width: screenWidth(context) * 0.4,
                                    height: 40,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                SkeletonParagraph(
                                  style: SkeletonParagraphStyle(
                                    padding: const EdgeInsets.only(top: 12 + 24 + 12),
                                    lines: 2,
                                    lineStyle: SkeletonLineStyle(
                                      height: 24,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SkeletonParagraph(
                                  style: SkeletonParagraphStyle(
                                    padding: const EdgeInsets.only(top: 12 + 24 + 12),
                                    lines: 2,
                                    lineStyle: SkeletonLineStyle(
                                      height: 24,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                SkeletonLine(
                                  style: SkeletonLineStyle(
                                    padding: const EdgeInsets.only(top: 12),
                                    width: screenWidth(context) * 0.6,
                                    height: 24,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: screenHeight(context),
                              ),
                              child: TextFormField(
                                onChanged: (newNotes) async {
                                  currentPresentation = await store.mutatePresentation(
                                    oldPresentation: currentPresentation,
                                    speakerNotes: newNotes,
                                  );
                                  setState(() {});
                                },
                                keyboardAppearance: Brightness.dark,
                                scrollPhysics: const NeverScrollableScrollPhysics(),
                                minLines: null,
                                maxLines: null,
                                cursorRadius: const Radius.circular(16),
                                cursorColor: colorScheme.onSurface,
                                style: MainText.textStyle,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter speaker notes and information that you want to use during your presentation.",
                                ),
                                initialValue: currentPresentation?[store.presentationNotesKey] ?? "Error loading speaker notes. This presentation does not seem to be initialized correctly. Please contact the developer.",
                              ),
                            ),
                          ),
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.only(top: 80 - 48),
                        child: GestureDetector(
                          onTap: () => navigateToAvailablePresenter(context, currentPresentation),
                          onLongPress: () => navigateToAvailablePresenter(
                            context,
                            currentPresentation,
                            preferMinimalPresenter: true,
                          ),
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) => 
                            SweepGradient(
                              transform: const GradientRotation(math.pi),
                              colors: [
                                (() {
                                  final presentationsAvailable = store.presentationAvailable(currentPresentation);
                                  return serverIP != null
                                  ? (
                                      presentationsAvailable
                                        ? Colors.blue.shade900
                                        : Colors.green.shade900
                                  )
                                  : (
                                      presentationsAvailable
                                        ? Colors.yellow.shade900
                                        : Colors.black
                                  );
                                })(),
                                Colors.white,
                              ],
                            ).createShader(bounds),
                              child: const Icon(
                              Icons.play_arrow_outlined,
                              size: 128,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  width: screenWidth(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: appDefaultCurve,
                    margin: EdgeInsets.all(widget.editing ? 0 : 16),
                    decoration: BoxDecoration(
                      borderRadius: _presentationsExpanded
                      ? BorderRadius.vertical(
                        top: Radius.circular(widget.editing ? 0 : 40),
                        bottom: Radius.circular(widget.editing && !_presentationsExpanded ? 0 : 24),
                      )
                      : BorderRadius.circular(widget.editing ? 0 : 40),
                      color: colorScheme.surface,
                    ),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _presentationsExpanded = !_presentationsExpanded),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(colorScheme.surface),
                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                            splashFactory: NoSplash.splashFactory,
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widget.editing ? 0 : 40),
                            )),
                          ),
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.only(left: 32, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Skeleton(
                                    isLoading: currentPresentation?[store.presentationNameKey] == null,
                                    skeleton: SkeletonLine(
                                      style: SkeletonLineStyle(
                                        width: 128,
                                        height: 32,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      switchInCurve: Curves.easeInOut,
                                      switchOutCurve: Curves.easeInOut,
                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      child: SingleChildScrollView(
                                        key: ValueKey<String?>(currentPresentation?[store.presentationNameKey]),
                                        child: Row(
                                          children: [
                                            SmallLabel(currentPresentation?[store.presentationNameKey] ?? "Loading..."),
                                            const SizedBox(
                                              width: 8,
                                              height: 80,
                                            ),
                                            Icon(
                                              _presentationsExpanded ? Icons.arrow_drop_up_outlined : Icons.arrow_drop_down_outlined,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: IconButton(
                                        onPressed: () => hasPro
                                        ? _changeEditingMode(wasTimerButtonPressed: true)
                                        : Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => const GetProScreen(),
                                        )),
                                        icon: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 100),
                                          switchInCurve: Curves.easeInOut,
                                          switchOutCurve: Curves.easeInOut,
                                          transitionBuilder: (Widget child, Animation<double> animation) {
                                            return ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            );
                                          },
                                          child: Icon(
                                            _isEditingTimer ? Icons.notes_outlined : Icons.timer_outlined,
                                            key: ValueKey<bool>(_isEditingTimer),
                                          ),
                                        ),
                                      )
                                    ),
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: IconButton(
                                        onPressed: () {
                                          if (widget.editing) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          }
                                          _changeEditingMode();
                                        },
                                        icon: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 100),
                                          switchInCurve: Curves.easeInOut,
                                          switchOutCurve: Curves.easeInOut,
                                          transitionBuilder: (Widget child, Animation<double> animation) {
                                            return ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            );
                                          },
                                          child: Icon(
                                            widget.editing ? Icons.check_outlined : Icons.edit_outlined,
                                            key: ValueKey<bool>(widget.editing),
                                          ),
                                        ),
                                      )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: appDefaultCurve,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: _presentationsExpanded
                          ? (() {
                            double defaultHeight = 80 + ( globalPresentations?.length ?? 2 ) * 72 - 72 + 16;
                            return defaultHeight < screenHeight(context) - 192 ? defaultHeight : screenHeight(context) - 256;
                          })()
                          : 0,
                          child: ListView(
                            children: [
                              for (Map<String, dynamic> p in globalPresentations ?? List.generate(2, (index) => {})) globalPresentations != null
                              ? p[store.presentationNameKey] == ( currentPresentation ?? {} )[store.presentationNameKey]
                                ? const SizedBox()
                                : AppAnimatedSwitcher(
                                  value: !_presentationsExpanded,
                                  fading: true,
                                  trueChild: const SizedBox(
                                    height: 72,
                                  ),
                                  falseChild: TextButton(
                                    onPressed: () async {
                                      setState(() => _presentationsExpanded = false);
                                      await Future.delayed(const Duration(milliseconds: 300));
                                      setState(() => currentPresentation = p);
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      )),
                                      backgroundColor: MaterialStateProperty.all(colorScheme.surface),
                                    ),
                                    child: Container(
                                      height: 72,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SmallLabel(p[store.presentationNameKey] ?? "Error"),
                                          IconButton(
                                            onPressed: () => showBooleanDialog(
                                              context: context,
                                              onYes: () async {
                                                await store.mutatePresentation(oldPresentation: p, isDeleting: true);
                                                setState(() {});
                                              },
                                              title: "Delete ${p[store.presentationNameKey]}?",
                                            ),
                                            icon: Icon(
                                              Icons.close_outlined,
                                              color: colorScheme.onSurface.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                )
                              : SkeletonLine(
                                style: SkeletonLineStyle(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  borderRadius: BorderRadius.circular(16),
                                  width: screenWidth(context),
                                  height: 72,
                                ),
                              ),
                              Container(
                                height: 96,
                                alignment: Alignment.center,
                                child: AppTextButton(
                                  onPressed: () => !hasPro
                                  ? Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const GetProScreen(),
                                  ))
                                  : showFullscreenDialog(
                                    context: context,
                                    closeOnBackgroundTap: false,
                                    content: SizedBox(
                                      height: screenHeight(context) / 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Material(
                                            child: SmallHeading("Add a presentation"),
                                          ),
                                          const SizedBox(height: 64),
                                          Material(
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 64),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: colorScheme.onSurface),
                                              ),
                                              height: 64,
                                              alignment: Alignment.center,
                                              child: TextField(
                                                onChanged: (value) => setState(() => _name = value),
                                                decoration: const InputDecoration.collapsed(hintText: "Enter a project name"),
                                                textAlign: TextAlign.center,
                                                style: MainText.textStyle.copyWith(),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth(context) / 2,
                                                child: IconButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  iconSize: 32,
                                                  color: colorScheme.onSurface,
                                                  icon: const Icon(Icons.close_outlined),
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth(context) / 2,
                                                child: IconButton(
                                                  onPressed: () async {
                                                    checkForName(String currentName) {
                                                      if (currentName.length > 16 && !currentName.contains(" 2")) {
                                                        return checkForName(currentName.substring(0, 15));
                                                      }
                                                      for (
                                                        Map<String, dynamic> p in
                                                        globalPresentations ?? [{store.presentationNameKey: _name}]
                                                      ) {
                                                        if (p[store.presentationNameKey] == currentName) {
                                                          return checkForName(currentName + " 2");
                                                        }
                                                      }
                                                      return currentName;
                                                    }
                                                    String finalName = checkForName(_name ?? "Presentation");
                                                    await store.mutatePresentation(
                                                      oldPresentation: null,
                                                      name: finalName,
                                                    );
                                                    Navigator.pop(context);
                                                    setState(() => _name = null);
                                                  },
                                                  padding: EdgeInsets.all(( ( screenWidth(context) / 2 ) - 32 ) / 2),
                                                  iconSize: 32,
                                                  color: colorScheme.onSurface,
                                                  icon: const Icon(Icons.check_outlined),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  label: "Add a presentation",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}