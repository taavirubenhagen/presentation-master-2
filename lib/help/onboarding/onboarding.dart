import 'package:flutter/material.dart';

import 'package:overlay_tooltip/overlay_tooltip.dart';

import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';
import 'package:presentation_master_2/help/onboarding/mockups.dart';
import 'package:presentation_master_2/store.dart' as store;




class OnboardingSlides extends StatelessWidget {
  const OnboardingSlides({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(32).copyWith(
            top: 64, bottom: 32 + MediaQuery.paddingOf(context).bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                const OnboardingMockupIllustration(),
                const SizedBox(height: 64),
                LargeLabel("Thank you for using Presentation Master 2, the all-in-one presentation remote control."),
              ],
            ),
            const SizedBox(height: 128),
            AppTextButton(
              onPressed: () {
                Navigator.pop(context);
                onboardingTooltipController.start();
                PresentationMaster2.setAppState(context);
              },
              next: true,
              label: "Take a tour",
            ),
          ],
        ),
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
    required this.child,
  });

  final int displayIndex;
  final TooltipHorizontalPosition horizontalPosition;
  final TooltipVerticalPosition verticalPosition;
  final String message;
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
                      label: controller.nextPlayIndex <
                              controller.playWidgetLength - 1
                          ? "Next"
                          : "Got it",
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
