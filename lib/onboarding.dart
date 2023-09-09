import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:overlay_tooltip/overlay_tooltip.dart';

import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';




class OnboardingSlides extends StatelessWidget {
  const OnboardingSlides({
    super.key,
  });

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
              SmallHeading("Thank you for using Presentation Master 2."),
              // TODO: Add illustration animation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colorScheme.onSurface),
                    ),
                    width: screenWidth(context) * 0.1,
                    height: screenWidth(context) * 0.1 * 1.8,
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 48,
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colorScheme.onSurface),
                        ),
                        width: screenWidth(context) * 0.3,
                        height: screenWidth(context) * 0.3 * 10/16,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme.onSurface,
                        ),
                        width: screenWidth(context) * 0.3,
                        height: 4,
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  AppTextButton(
                    onPressed: () {
                      onboardingTooltipController.start();
                      onboarding = true;
                      Navigator.pop(context);
                    },
                    next: true,
                    label: "Take tour",
                  ),
                  const SizedBox(height: 16),
                  AppTextButton(
                    onPressed: () => Navigator.pop(context),
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
    this.onAdditionalButtonPressed,
    this.additionalButtonLabel,
    required this.child,
  });

  final int displayIndex;
  final TooltipHorizontalPosition horizontalPosition;
  final TooltipVerticalPosition verticalPosition;
  final String message;
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
                      label: controller.nextPlayIndex < controller.playWidgetLength - 1 ? "Next" : "Got it",
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