import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presentation_master_2/home.dart';

import 'package:presentation_master_2/main.dart';




class BaseText extends Text {
  BaseText(
    String data,
    style,
    {
      required textAlign,
      required isOnPrimary,
      required isOnBackground,
      super.key
    }
  ) : super(
    data,
    textAlign: textAlign,
    style: style.copyWith(color: isOnPrimary ? colorScheme.onPrimary : ( isOnBackground ? colorScheme.onSurface : colorScheme.onSurface )),
  );
}


class MainText extends BaseText {
  MainText(data, {isOnPrimary = false, isOnBackground = false, super.key})
  : super(data, textStyle, textAlign: TextAlign.left, isOnPrimary: isOnPrimary, isOnBackground: isOnBackground);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
}


class SmallLabel extends BaseText {
  SmallLabel(data, {isOnPrimary = false, isOnBackground = false, super.key})
  : super(data, textStyle, textAlign: TextAlign.left, isOnPrimary: isOnPrimary, isOnBackground: isOnBackground);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 16,
  );
}


class MediumLabel extends BaseText {
  MediumLabel(data, {isOnPrimary = false, isOnBackground = false, super.key})
  : super(data, textStyle, textAlign: TextAlign.left, isOnPrimary: isOnPrimary, isOnBackground: isOnBackground);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 20,
  );
}


class LargeLabel extends BaseText {
  LargeLabel(data, {isOnPrimary = false, isOnBackground = false, super.key})
  : super(data, textStyle, textAlign: TextAlign.left, isOnPrimary: isOnPrimary, isOnBackground: isOnBackground);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 24,
  );
}


class HugeLabel extends BaseText {
  HugeLabel(data, {isOnPrimary = false, isOnBackground = false, super.key})
  : super(data, textStyle, textAlign: TextAlign.left, isOnPrimary: isOnPrimary, isOnBackground: isOnBackground);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 72,
  );
}


class ButtonLabel extends BaseText {
  ButtonLabel(data, {isOnPrimary = false, isOnBackground = false, super.key})
  : super(data, textStyle, textAlign: TextAlign.center, isOnPrimary: isOnPrimary, isOnBackground: isOnBackground);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 20,
  );
}


class SmallHeading extends BaseText {
  SmallHeading(data, {isOnPrimary = false, isOnBackground = false, super.key})
  : super(data, textStyle, textAlign: TextAlign.center, isOnPrimary: isOnPrimary, isOnBackground: isOnBackground);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 28,
    wordSpacing: 2,
  );
}


class MediumHeading extends BaseText {
  MediumHeading(data, {isOnPrimary = false, isOnBackground = false, super.key})
  : super(data, textStyle, textAlign: TextAlign.left, isOnPrimary: isOnPrimary, isOnBackground: isOnBackground);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 36,
    wordSpacing: 2,
  );
}




class AppAnimatedSwitcher extends StatelessWidget {
  const AppAnimatedSwitcher({
    super.key,
    required this.value,
    this.milliseconds = 100,
    this.switchInCurve = Curves.easeInOut,
    this.switchOutCurve = Curves.easeInOut,
    this.fading = false,
    required this.trueChild,
    required this.falseChild,
  });

  final bool value;
  final int milliseconds;
  final Curve switchInCurve;
  final Curve switchOutCurve;
  final bool fading;
  final Widget trueChild;
  final Widget falseChild;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: milliseconds),
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return fading
        ? FadeTransition(
          opacity: animation,
          child: child,
        )
        : ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: SizedBox(
        key: ValueKey<bool>(value),
        child: value ? trueChild : falseChild,
      ),
    );
  }
}




class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.onPressed,
    this.secondary = false,
    this.isOnBackground = false,
    this.isActive = true,
    this.isLink = false,
    required this.label,
  });

  final void Function() onPressed;
  final bool secondary;
  final bool isOnBackground;
  final bool isActive;
  final bool isLink;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:  isActive ? 1 : 0.2,
      child: TextButton(
        onPressed: isActive ? onPressed : () {},
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: secondary ? BorderSide(width: 2, color: colorScheme.onSurface.withOpacity(isActive ? 0.25 : 0.1)) : BorderSide.none,
          )),
          backgroundColor: secondary
          ? MaterialStateProperty.all(Colors.transparent)
          : ( isOnBackground ? MaterialStateProperty.all(colorScheme.surface) : null ),
          overlayColor: isActive ? null : MaterialStateProperty.all(Colors.transparent),
        ),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
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
            child: SizedBox(
              key: ValueKey<bool>(isActive),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonLabel(label),
                  const SizedBox(width: 16),
                  if (isLink) const Icon(Icons.open_in_new_outlined),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




void showFullscreenDialog({
  required BuildContext context,
  bool closeOnBackgroundTap = true,
  required Widget content,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.9),
    builder: (BuildContext context) => GestureDetector(
      onTap: () => closeOnBackgroundTap ? Navigator.pop(context) : null,
      child: Center(
        child: content,
      ),
    ),
  );
}




void showBooleanDialog({
  required BuildContext context,
  bool readOnly = false,
  required String title,
  required Function() onYes,
}) {
  showFullscreenDialog(
    context: context,
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            child: SmallHeading(title),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              SizedBox(
                width: readOnly ? screenWidth(context) - 64 : screenWidth(context) / 2,
                height: screenWidth(context) / 4,
                child: Icon(
                  readOnly ? Icons.check_outlined : Icons.close_outlined,
                  size: 32,
                  color: colorScheme.onSurface,
                ),
              ),
              if (!readOnly) Expanded(
                child: AspectRatio(
                  aspectRatio: 1/1,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onYes();
                    },
                    iconSize: 32,
                    color: colorScheme.onSurface,
                    icon: const Icon(Icons.check_outlined),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}