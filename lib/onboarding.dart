import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:overlay_tooltip/overlay_tooltip.dart';

import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';
import 'package:presentation_master_2/mockups.dart';




class OnboardingSlides extends StatelessWidget {
  const OnboardingSlides({super.key});

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        showBooleanDialog(
          context: context,
          title: "Exit app?",
          onYes: () => SystemNavigator.pop(),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorScheme.surface,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: colorScheme.surface,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32).copyWith(top: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              const SizedBox(),
              const OnboardingMockupIllustration(),
              LargeLabel("Thank you for using Presentation Master 2, the remote control for your PowerPoint presentations."),
              Column(
                children: [
                  AppTextButton(
                    onPressed: () {
                      onboardingTooltipController.start();
                      Navigator.pop(context);
                    },
                    next: true,
                    label: "Take tour",
                  ),
                  const SizedBox(height: 16),
                  AppTextButton(
                    onPressed: () {
                      PresentationMaster2.setAppState(context, () => onboarding = false);
                      Navigator.pop(context);
                    },
                    secondary: true,
                    label: "Skip",
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}




class AppOverlayTooltip extends StatelessWidget {
  const AppOverlayTooltip({
    super.key,
    required this.displayIndex,
    this.horizontalPosition = TooltipHorizontalPosition.WITH_WIDGET,
    this.verticalPosition = TooltipVerticalPosition.BOTTOM,
    required this.message,
    /// If true, the 'Next' button will be labeled 'Skip'	instead
    this.skipButton = false,
    this.onAdditionalButtonPressed,
    this.additionalButtonLabel,
    required this.child,
  });

  final int displayIndex;
  final TooltipHorizontalPosition horizontalPosition;
  final TooltipVerticalPosition verticalPosition;
  final String message;
  final bool skipButton;
  final Function()? onAdditionalButtonPressed;
  final String? additionalButtonLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OverlayTooltipItem(
      displayIndex: displayIndex,
      tooltipHorizontalPosition: horizontalPosition,
      tooltipVerticalPosition: verticalPosition,
      tooltip: (controller) => Container(
        margin: const EdgeInsets.all(16),
        width: 256,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.surface,
        ),
        child: Opacity(
          opacity: 0.8,
          child: Column(
            children: [
              SmallLabel(message),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppTextButton(
                      onPressed: controller.next,
                      mini: true,
                      label: controller.nextPlayIndex < controller.playWidgetLength - 1 ? ( skipButton ? "Skip" : "Next" ) : "Got it",
                    ),
                  ),
                  if (onAdditionalButtonPressed != null && additionalButtonLabel != null) const SizedBox(width: 8),
                  if (onAdditionalButtonPressed != null && additionalButtonLabel != null) Expanded(
                    child: AppTextButton(
                      onPressed: onAdditionalButtonPressed ?? () {},
                      mini: true,
                      label: additionalButtonLabel ?? "[Error]",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}