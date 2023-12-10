// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:presentation_master_2/design.dart';
import 'package:zwidget/zwidget.dart';

import 'package:presentation_master_2/main.dart';


laptopWidth(context) => screenWidth(context) * 0.5;
phoneHeight(context) => laptopWidth(context) / 2;
phoneWidth(context) => phoneHeight(context) / 1.8;
phoneDownsizingFactor(context) => phoneHeight(context) / screenHeight(context);


final _slideController = PageController();
int? _phoneButtonState;




class OnboardingMockupIllustration extends StatefulWidget {
  const OnboardingMockupIllustration({
    super.key,
  });

  @override
  State<OnboardingMockupIllustration> createState() => _OnboardingMockupIllustrationState();
}

class _OnboardingMockupIllustrationState extends State<OnboardingMockupIllustration> {

  Timer _timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(milliseconds: 3600),
      (timer) async {
        if (!_slideController.hasClients) {
          logger.e('_slideController.hasClients is false. Aborting mockup animation.');
          return;
        }
        _phoneButtonState = ( _slideController.page?.round() ?? 0 ) == 1 ? 0 : 1;
        await Future.delayed(const Duration(milliseconds: 50));
        ( _slideController.page?.round() ?? 0 ) == 1
        ? _slideController.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: appDefaultCurve,
        )
        : _slideController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: appDefaultCurve,
        );
        await Future.delayed(const Duration(milliseconds: 150));
        _phoneButtonState = null;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        LaptopFrame(
          phonePadding: true,
          child: ExamplePresentationMockup(
            controller: _slideController,
          ),
        ),
        ZWidget.backwards(
          rotationX: -math.pi / 6,
          perspective: math.pi * 1,
          layers: 2,
          depth: 8,
          midChild: Transform.rotate(
            angle: math.pi / 16,
            child: const PhoneFrame(
              laptopPadding: true,
              child: NotePresenterMockup(),
            ),
          ),
        ),
      ],
    );
  }
}




class LaptopFrame extends StatelessWidget {
  const LaptopFrame({
    super.key,
    required this.phonePadding,
    required this.child,
  });

  final bool phonePadding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.onSurface),
            color: colorScheme.background,
          ),
          width: laptopWidth(context),
          height: laptopWidth(context) * 9/16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: child,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: colorScheme.onSurface,
          ),
          width: laptopWidth(context),
          height: 4,
        ),
        SizedBox(height: phonePadding ? phoneHeight(context) / 2 : 0),
      ],
    );
  }
}




class PresentationMaster2ForPCMockup extends StatelessWidget {
  const PresentationMaster2ForPCMockup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Text(
        "Use the mobile app to connect.",
        style: GoogleFonts.lexend(
          fontSize: 4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}




class ExamplePresentationMockup extends StatelessWidget {
  const ExamplePresentationMockup({
    super.key,
    this.controller,
  });

  final PageController? controller;

  @override
  Widget build(BuildContext context) {

    return PageView(
      controller: controller,
      children: [
        Container(
          padding: const EdgeInsets.all(8).copyWith(bottom: 10),
          alignment: Alignment.center,
          child: Text(
            "Sigma Male\nGrindset Theory 🔥",
            style: GoogleFonts.flowCircular(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are Sigma Males > Alpha Males??? 😮",
                style: GoogleFonts.flowCircular(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "❌ Sigma Male Grindset or Hustle Culture Memes"
                "\n❌ refers to a series of memes"
                "\n✅ that both parody and support motivational memes"
                "\n✅ which promote self-improvement and focus ...",
                style: GoogleFonts.flowCircular(
                  fontSize: 4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    super.key,
    required this.laptopPadding,
    required this.child,
  });

  final bool laptopPadding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: laptopPadding ? EdgeInsets.only(left: phoneHeight(context) / 4) : EdgeInsets.zero,
      width: phoneHeight(context) / 1.8,
      height: phoneHeight(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.onSurface,
        ),
        color: colorScheme.background,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }
}




class HomeMockup extends StatefulWidget {
  const HomeMockup({super.key});

  @override
  State<HomeMockup> createState() => _HomeMockupState();
}

class _HomeMockupState extends State<HomeMockup> {


  bool _playButtonLarge = false;
  Timer _timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(milliseconds: 400),
      (timer) async => setState(() => _playButtonLarge = !_playButtonLarge),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.all(phoneDownsizingFactor(context) * 16 * 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(phoneDownsizingFactor(context) * 40),
            color: colorScheme.surface,
          ),
          height: phoneDownsizingFactor(context) * 80,
          alignment: Alignment.center,
          child: Text(
            "Presentation 1",
            style: GoogleFonts.flowCircular(
              fontSize: phoneDownsizingFactor(context) * ButtonLabel.textStyle.fontSize,
            ),
          ),
        ),
        AnimatedScale(
          duration: const Duration(milliseconds: 400),
          curve: _playButtonLarge ? Curves.easeIn : Curves.easeOut,
          scale: _playButtonLarge ? 1.25 : 1,
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) => 
            SweepGradient(
              transform: const GradientRotation(math.pi),
              colors: [
                Colors.white,
                Colors.blue.shade900,
              ],
            ).createShader(bounds),
            child: Icon(
              Icons.play_arrow_rounded,
              size: phoneDownsizingFactor(context) * 128,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: phoneDownsizingFactor(context) * 64),
          width: phoneWidth(context),
          height: phoneDownsizingFactor(context) * 80,
          color: colorScheme.surface,
          alignment: Alignment.center,
          child: Text(
            "Help Center",
            style: GoogleFonts.flowCircular(
              fontSize: phoneDownsizingFactor(context) * ButtonLabel.textStyle.fontSize,
            ),
          ),
        ),
      ],
    );
  }
}




class NotePresenterMockup extends StatefulWidget {
  const NotePresenterMockup({super.key});

  @override
  State<NotePresenterMockup> createState() => _NotePresenterMockupState();
}

class _NotePresenterMockupState extends State<NotePresenterMockup> {

  Timer _timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    // Necessary for the animation state to reach this widget
    _timer = Timer.periodic(
      const Duration(milliseconds: 3600),
      (timer) async {
        if (!_slideController.hasClients) {
          return;
        }
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorScheme.onSurface)),
          ),
          width: phoneWidth(context),
          height: phoneHeight(context) * 2/3 - 2,
          padding: const EdgeInsets.all(8).copyWith(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Speaker notes",
                style: GoogleFonts.flowCircular(
                  // Largest heading size in speaker notes Markdown
                  fontSize: phoneDownsizingFactor(context) * 40,
                ),
              ),
              SizedBox(height: phoneDownsizingFactor(context) * 32),
              Text(
                "Enter speaker notes here to see them during your presentation"
                "\n\nNovus ordo seclorum",
                style: GoogleFonts.flowCircular(
                  // Normal paragraph size in speaker notes Markdown
                  fontSize: phoneDownsizingFactor(context) * 22,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            for (int i in List.generate(2, (index) => index))
            ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: i == 0 ? const Radius.circular(8 - 1) : Radius.zero,
                    bottomRight: i == 1 ? const Radius.circular(8 - 1) : Radius.zero,
                  ),
                  color: _phoneButtonState == i
                  ? colorScheme.onBackground
                  : colorScheme.background,
                ),
                width: phoneWidth(context) / 2 - 1.5,
                height: phoneHeight(context) * 1/3,
                alignment: Alignment.center,
                child: Icon(
                  i == 0 ? Icons.arrow_back_ios_new_outlined : Icons.arrow_forward_ios_outlined,
                  size: phoneDownsizingFactor(context) * 32 * 2,
                  color: colorScheme.onBackground,
                ),
              ),
              if (i == 0) Container(
                width: 1,
                height: phoneHeight(context) * 1/3,
                color: colorScheme.onBackground,
              ),
            ],
          ],
        ),
      ],
    );
  }
}