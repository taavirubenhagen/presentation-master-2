// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';




class HelpScaffold extends StatelessWidget {
  const HelpScaffold({
    super.key,
    this.actionButton,
    this.onBottomButtonPressed,
    this.bottomButtonIsLink = false,
    this.bottomButtonLabel,
    required this.tiles,
  });

  final Widget? actionButton;
  final Function()? onBottomButtonPressed;
  final bool bottomButtonIsLink;
  final String? bottomButtonLabel;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 96,
        backgroundColor: colorScheme.background,
        leadingWidth: 96,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.all(16),
          iconSize: 32,
          color: colorScheme.onSurface,
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        actions: [
          actionButton ?? const SizedBox(),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: actionButton == null ? 0 : 16),
            child: ListView(
              children: tiles,
            ),
          ),
          if (onBottomButtonPressed != null && bottomButtonLabel != null) Positioned(
            bottom: 0,
            child: AppTextButton(
              onPressed: onBottomButtonPressed!,
              docked: true,
              isLink: bottomButtonIsLink,
              label: bottomButtonLabel!,
            ),
          ),
        ],
      ),
    );
  }
}




class AppHelpTile extends StatelessWidget {
  const AppHelpTile({
    super.key,
    required this.onButtonPressed,
    required this.title,
    this.link = false,
  });

  final Function() onButtonPressed;
  final String title;
  final bool link;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: TextButton(
        onPressed: onButtonPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorScheme.surface),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          )),
        ),
        child: Container(
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LargeLabel(title),
              Icon(
                link ? Icons.open_in_new_rounded : Icons.arrow_forward_ios_rounded,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}