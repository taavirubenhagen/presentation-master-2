// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:presenter_2/main.dart';
import 'package:presenter_2/design.dart';
import 'package:presenter_2/components.dart';




// TODO: Fix PageController error
class HelpPanel extends StatefulWidget {
  const HelpPanel({required this.body, required this.controller, super.key});

  final Widget body;
  final SnappingSheetController controller;

  @override
  State<HelpPanel> createState() => _HelpPanelState();
}

class _HelpPanelState extends State<HelpPanel> {

  final PageController _firstHeadingPageController = PageController();
  final PageController _secondHeadingPageController = PageController();
  final PageController _firstContentPageController = PageController();
  final PageController _secondContentPageController = PageController();

  final List<List> _helpSections = [
    ["???", Container()],
    ["Connect a PC", Container()],
    ["Switch theme", Container()],
  ];

  void _switchHelpSection(int index) {
    _secondHeadingPageController.jumpToPage(index);
    _firstHeadingPageController.animateToPage(
      index != -1 ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      curve: Cubic(.4, 0, .2, 1),
    );
    _secondContentPageController.jumpToPage(index);
    _firstContentPageController.animateToPage(
      index != -1 ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      curve: Cubic(.4, 0, .2, 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: widget.controller,
      onSheetMoved: (data) => setState(() {}),
      snappingPositions: [
        SnappingPosition.pixels(positionPixels: -32),
        SnappingPosition.factor(positionFactor: 0.5),
        SnappingPosition.factor(positionFactor: 0.9),
      ],
      grabbingHeight: 32,
      grabbing: Material(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        color: colorScheme.surface,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 64,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
      sheetBelow: SnappingSheetContent(
        draggable: true,
        child: Scaffold(
          body: Container(
            color: colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: AppOutlinedButton.defaultHeight + 2 * 16,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _firstHeadingPageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            // TODO: Center headings
                            LargeHeading("Help center"),
                            PageView.builder(
                              controller: _secondHeadingPageController,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _helpSections.length,
                              itemBuilder: (BuildContext context, int i) => Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _switchHelpSection(0),
                                    iconSize: 32,
                                    color: colorScheme.onSurface,
                                    icon: Icon(Icons.arrow_back_rounded),
                                  ),
                                  LargeHeading(_helpSections[i][0]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppOutlinedButton(
                        onPressed: () => widget.controller.snapToPosition(SnappingPosition.pixels(positionPixels: 32)),
                        iconData: Icons.check_rounded,
                        text: "Close",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _firstContentPageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _helpSections.length,
                        itemBuilder: (BuildContext context, int i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                          child: TextButton(
                            onPressed: () => _switchHelpSection(i),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: colorScheme.onSurface),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all(Size.fromHeight(96)),
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 32)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_card,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 32),
                                    MediumHeading(_helpSections[i][0]),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      PageView.builder(
                        controller: _secondContentPageController,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _helpSections.length,
                        itemBuilder: (BuildContext context, int i) => _helpSections[i][1]
                      ),
                      // TODO: D
                      /*Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // TODO: Add illustration
                        children: [
                          LargeHeading("Page not found"),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppOutlinedButton(
                                onPressed: () => _switchHelpSection(0),
                                text: "Go back",
                              ),
                            ],
                          ),
                          const SizedBox(height: 64),
                        ],
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Stack(
        children: [
          widget.body,
          IgnorePointer(
            ignoring: true,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 2000),
              color: Colors.black.withOpacity(
                widget.controller.isAttached && widget.controller.currentPosition > 0
                ? ( widget.controller.currentPosition < screenHeight(context) * 2
                  ? widget.controller.currentPosition / screenHeight(context) / 2
                  : 1
                )
                : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class HelpSection extends StatelessWidget {
  const HelpSection({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}