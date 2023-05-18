// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:snapping_sheet/snapping_sheet.dart';

import 'package:presenter_2/main.dart';
import 'package:presenter_2/design.dart';
import 'package:presenter_2/components.dart';
import 'package:presenter_2/control.dart';
import 'package:presenter_2/help.dart';
import 'package:presenter_2/editor.dart';




class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _snappingSheetController = SnappingSheetController();
  String x = "No name";

  @override
  Widget build(BuildContext context) {
    return HelpPanel(
      controller: _snappingSheetController,
      body: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          toolbarHeight: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            //statusBarColor: Colors.white,
            //statusBarIconBrightness: Brightness.light,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    //border: Border.all(color: colorScheme.onSurface.withOpacity(1)),
                    //color: Colors.grey.shade100,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                SmallLabel(x + "Presentation 1"),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: Icon(
                                  Icons.timer_outlined,
                                  size: 24,
                                )
                              ),
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: IconButton(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => NoteEditor(presentationIndex: 0),   // TODO
                                  )),
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    size: 24,
                                  ),
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 256 - 80,
                        child: TextField(
                          enabled: false,
                          minLines: 4,
                          maxLines: 4096,
                          style: MainText.textStyle,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Tap to add speaker notes for your presentation.",
                            hintStyle: MainText.textStyle.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) => LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0, 1],
                        colors: [
                          Colors.purple,
                          Colors.red,
                        ],
                      ).createShader(bounds),
                      child: Icon(
                        Icons.no_cell_outlined,
                        size: 64,
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 32),
                    MediumHeading("No PC connected"),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        AppOutlinedButton(
                          onPressed: () async {
                            //control();

                            await Permission.bluetoothScan.request();
                            await Permission.bluetoothConnect.request();

                            setState(() => x = "S");

                            FlutterBlue flutterBlue = FlutterBlue.instance;

                            logger.i(await flutterBlue.connectedDevices);
                            x = ( await flutterBlue.connectedDevices ).toString();
                            setState(() {});
                            
                            /*flutterBlue.startScan(timeout: const Duration(seconds: 4));

                            flutterBlue.scanResults.listen((results) async {
                              setState(() => x = "W");
                              for (ScanResult r in results) {
                                setState(() => x = r.device.name);
                                //_device ??= r.device;
                              }
                            });
                            /*Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Presenter(minutes: 15),
                            ));*/*/
                          },
                          iconData: Icons.wifi_outlined,
                          text: "Connect",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // The Builder is necessary for the Scaffold to be found
              Builder(
                builder: (context) => AppPrimaryButton(
                  onPressed: () => _snappingSheetController.snapToPosition(SnappingPosition.factor(positionFactor: 0.5)),
                  minWidth: screenWidth(context),
                  text: "How to",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}