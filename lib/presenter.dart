// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:animate_gradient/animate_gradient.dart';

import 'package:presenter_2/main.dart';
import 'package:presenter_2/design.dart';




class Presenter extends StatefulWidget {
  const Presenter({this.textSize = 20, this.minutes = 0, super.key});

  final double textSize;
  final int minutes;

  @override
  State<Presenter> createState() => _PresenterState();
}

class _PresenterState extends State<Presenter> {

  Timer _timer = Timer(const Duration(), () {});
  int _timerMinutes = 0;
  
  bool _isTextFieldEditable = false;

  bool _isMousePadExpanded = true;
  bool _isMousePadWidthExpanded = true;
  bool _isMousePadHeightExpanded = true;

  void control({movesBack = false}) {
    //
  }

  @override
  void initState() {
    super.initState();

    _timerMinutes = widget.minutes;
    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      setState(() => _timerMinutes--);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          //statusBarColor: Colors.white,
          //statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: GestureDetector(
        onDoubleTap: () => _isTextFieldEditable = true,
        child: Column(
          children: [
            Container(
              height: screenHeight(context) / 2,
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                readOnly: !_isTextFieldEditable,
                minLines: 4,
                maxLines: 4096,
                style: MainText.textStyle.copyWith(fontSize: widget.textSize),
                initialValue: "Example note:\n\nPoint 1: Additional information about point 1\n\nAnother point: I don't really know what to write here lol xd.",
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Double tap to add speaker notes for your presentation.",
                ),
              ),
            ),
            SizedBox(
              height: screenHeight(context) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    onEnd: () => setState(() {
                      if (_isMousePadWidthExpanded == _isMousePadHeightExpanded) {
                        _isMousePadExpanded = _isMousePadWidthExpanded;
                        return;
                      }
                      _isMousePadExpanded ? _isMousePadWidthExpanded = false : _isMousePadHeightExpanded = true;
                    }),
                    duration: Duration(milliseconds: 200),
                    curve: Cubic(.4, 0, .2, 1),
                    margin: EdgeInsets.only(top: _isMousePadHeightExpanded ? 0 : screenHeight(context) / 2 - 256 - 16 - 48),
                    width: _isMousePadWidthExpanded ? screenWidth(context) : 48,
                    height: _isMousePadHeightExpanded ? screenHeight(context) / 2 - 256 - ( widget.minutes > 0 ? 16 : 0 ) : 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(_isMousePadHeightExpanded ? 0 : 8),),
                      color: colorScheme.onSurface.withOpacity(0.1),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: _isMousePadExpanded && _isMousePadHeightExpanded && _isMousePadWidthExpanded ? 200 : 100),
                          curve: Cubic(.4, 0, .2, 1),
                          opacity: _isMousePadExpanded && _isMousePadHeightExpanded && _isMousePadWidthExpanded ? 1 : 0,
                          child: TextButton(
                            onPressed: () {},   // TODO: Add hint that this is not a button
                            child: Icon(
                              Icons.mouse_outlined,
                              size: 32,
                              color: colorScheme.onSurface.withOpacity(0.1),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 400),
                          curve: Cubic(.4, 0, .2, 1),
                          right: 0,
                          top: 0,
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: TextButton(
                              onPressed: () => setState(() {
                                _isMousePadExpanded ? _isMousePadHeightExpanded = false : _isMousePadWidthExpanded = true;
                              }),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),)),
                                overlayColor: MaterialStateProperty.all(colorScheme.onPrimary.withOpacity(0.25)),
                              ),
                              child: AnimatedRotation(
                                duration: Duration(milliseconds: 400),
                                curve: Cubic(.4, 0, .2, 1),
                                turns: _isMousePadWidthExpanded || _isMousePadHeightExpanded ? 0 :  0.5,
                                child: Icon(
                                  Icons.expand_more_outlined,
                                  size: 24,
                                  color: colorScheme.onSurface.withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.minutes > 0) Divider(
                    height: 0,
                    color: colorScheme.onSurface.withOpacity(0.25),
                  ),
                  if (widget.minutes > 0) Container(
                    width: screenWidth(context) * _timerMinutes / widget.minutes,
                    height: 16,
                    color: colorScheme.primary,
                  ),
                  Divider(
                    height: 0,
                    color: colorScheme.onSurface.withOpacity(0.25),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 256,
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                                fixedSize: MaterialStateProperty.all(Size(screenWidth(context) / 2, 256)),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 32,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            VerticalDivider(
                              width: 0,
                              color: colorScheme.onSurface,
                            ),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(RoundedRectangleBorder()),
                                fixedSize: MaterialStateProperty.all(Size(screenWidth(context) / 2, 256)),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 32,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.minutes > 0) Positioned(
                        top: -1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8).copyWith(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
                            /*border: Border.all(
                              color: colorScheme.onSurface
                            ),*/
                            color: colorScheme.surface,
                          ),
                          height: 65,
                          alignment: Alignment.center,
                          child: HugeLabel(_timerMinutes < 10 ? "0$_timerMinutes" : _timerMinutes.toString()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}