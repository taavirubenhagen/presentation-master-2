import 'package:flutter/material.dart';

import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:presenter_2/main.dart';
import 'package:presenter_2/design.dart';




class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    required this.onPressed,
    this.iconData,
    required this.text,
    super.key,
  });

  final Function() onPressed;
  final IconData? iconData;
  final String text;

  static const double defaultHeight = 48;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: colorScheme.onSurface),
          ),
        ),
        fixedSize: MaterialStateProperty.all(const Size.fromHeight(defaultHeight)),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        backgroundColor: MaterialStateProperty.all(colorScheme.surface),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconData != null) Icon(
            iconData,
            color: colorScheme.onSurface,
          ),
          if (iconData != null) const SizedBox(width: 8),
          PrimaryButtonLabel(
            text,
          ),
          if (iconData != null) const SizedBox(width: 8),
        ],
      ),
    );
  }
}




class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    this.minWidth = 0,
    required this.text,
  });

  final Function() onPressed;
  final double minWidth;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        minimumSize: MaterialStateProperty.all(Size(minWidth, 48)),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
        backgroundColor: MaterialStateProperty.all(colorScheme.primary),
      ),
      child: PrimaryButtonLabel(
        text,
        isOnPrimary: true,
      ),
    );
  }
}