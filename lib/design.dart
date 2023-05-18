import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:presenter_2/main.dart';




class BaseText extends Text {
  BaseText(
    String data,
    style,
    {
      isOnPrimary = false,
      super.key
    }
  ) : super(
    data,
    style: style.copyWith(color: isOnPrimary ? colorScheme.onPrimary : colorScheme.onSurface),
    overflow: TextOverflow.clip,
  );
}


class MainText extends BaseText {
  MainText(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    //height: 1.5,
    //letterSpacing: 1,
    //wordSpacing: 2,
  );
}


class SmallLabel extends BaseText {
  SmallLabel(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 16,
  );
}


class MediumLabel extends BaseText {
  MediumLabel(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 18,
  );
}


class HugeLabel extends BaseText {
  HugeLabel(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 32,
  );
}


class PrimaryButtonLabel extends BaseText {
  PrimaryButtonLabel(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}


class LargeButtonLabel extends BaseText {
  LargeButtonLabel(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 18,
  );
}


class SmallSubtitle extends BaseText {
  SmallSubtitle(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    wordSpacing: 2,
  );
}


class SmallHeading extends BaseText {
  SmallHeading(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    wordSpacing: 2,
  );
}


class MediumHeading extends BaseText {
  MediumHeading(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    wordSpacing: 2,
  );
}


class LargeHeading extends BaseText {
  LargeHeading(data, {isOnPrimary = false, super.key}) : super(data, textStyle, isOnPrimary: isOnPrimary);

  static final TextStyle textStyle = GoogleFonts.lexend(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    wordSpacing: 2,
  );
}