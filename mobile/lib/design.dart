import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:presentation_master_2/main.dart';




class BaseText extends Text {
  BaseText(
    String data,
    style,
    {
      required Color? color,
      super.key
    }
  ) : super(
    data,
    textAlign: TextAlign.left,
    style: style.copyWith(
      //fontFamily: 'Trap',
      //fontWeight: FontWeight.w500,
      color: color ?? colorScheme.onSurface,
    ),
  );
}


class MainText extends BaseText {
  MainText(
    String data,
    {
      Color? color,
      super.key,
    })
  : super(data, textStyle, color: color);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
}


class SmallLabel extends BaseText {
  SmallLabel(
    String data,
    {
      Color? color,
      super.key,
    })
  : super(data, textStyle, color: color);

  static final TextStyle textStyle = GoogleFonts.dmMono(
    fontSize: 16,
  );
}


class LargeLabel extends BaseText {
  LargeLabel(
    String data,
    {
      Color? color,
      super.key,
    })
  : super(data, textStyle, color: color);

  static final TextStyle textStyle = GoogleFonts.dmMono(
    fontSize: 20,
  );
}


class ButtonLabel extends BaseText {
  ButtonLabel(
    String data,
    {
      Color? color,
      super.key,
    })
  : super(data, textStyle, color: color);

  static final TextStyle textStyle = GoogleFonts.dmMono(
    fontSize: 20,
  );
}


class Heading extends BaseText {
  Heading(
    String data,
    {
      Color? color,
      super.key,
    })
  : super(data, textStyle, color: color);

  static final TextStyle textStyle = GoogleFonts.dmMono(
    fontSize: 24,
    fontWeight: FontWeight.bold,
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
    this.mini = false,
    this.docked = false,
    this.onBackground = false,
    this.active = true,
    this.customIcon,
    this.isLink = false,
    this.next = false,
    this.loadingLabel,
    required this.label,
  });

  final void Function() onPressed;
  final bool secondary;
  final bool mini;
  final bool docked;
  final bool onBackground;
  final bool active;
  final IconData? customIcon;
  final bool isLink;
  final bool next;
  final String? loadingLabel;
  final String label;

  static const double defaultHeight = 72;
  static const double defaultBorderRadius = 16;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: !active || loadingLabel != null ? 0.2 : 1,
      child: TextButton(
        onPressed: active ? onPressed : () {},
        style: ButtonStyle(
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mini ? 8 : docked ? 0 : defaultBorderRadius),
            side: secondary ? BorderSide(width: 2, color: colorScheme.onSurface.withOpacity(active ? 0.25 : 0.1)) : BorderSide.none,
          )),
          backgroundColor: secondary
          ? WidgetStateProperty.all(Colors.transparent)
          : ( onBackground || docked ? WidgetStateProperty.all(colorScheme.surface) : null ),
          overlayColor: active ? null : WidgetStateProperty.all(Colors.transparent),
        ),
        child: Container(
          width: docked ? screenWidth(context) : null,
          height: mini
          ? 32
          : docked
            ? 80 + MediaQuery.paddingOf(context).bottom
            : defaultHeight,
          padding: EdgeInsets.symmetric(
            horizontal: mini ? 12 : 32,
          ).copyWith(
            bottom: docked ? MediaQuery.paddingOf(context).bottom : 0,
          ),
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
              key: ValueKey<bool>(active),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: loadingLabel != null
                ? [
                  mini ? SmallLabel(loadingLabel ?? 'ERROR') : ButtonLabel(loadingLabel ?? 'ERROR'),
                  if (loadingLabel != null) const SizedBox(width: 32),//Expanded(child: SizedBox()),
                  SizedBox(
                    width: mini ? 16 : 24,
                    height: mini ? 16 : 24,
                    child: CircularProgressIndicator(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ]
                : [
                  mini ? SmallLabel(label) : ButtonLabel(label),
                  if (isLink || next || customIcon != null) const SizedBox(width: 16),
                  if (isLink || next || customIcon != null) Icon(
                    customIcon ?? ( isLink ? Icons.open_in_new_outlined : Icons.arrow_forward_outlined ),
                  ),
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
    barrierColor: Colors.black,
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
  required String title,
  Function()? onYes,
}) {
  showFullscreenDialog(
    context: context,
    content: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: Text(
              title,
              style: LargeLabel.textStyle.copyWith(
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              SizedBox(
                width: onYes == null ? screenWidth(context) - 64 : screenWidth(context) / 2,
                height: screenWidth(context) / 4,
                child: Icon(
                  onYes == null ? Icons.check_outlined : Icons.close_outlined,
                  size: 32,
                  color: colorScheme.onSurface,
                ),
              ),
              if (onYes != null) Expanded(
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