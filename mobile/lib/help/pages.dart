// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:presentation_master_2/help/components.dart';
import 'package:presentation_master_2/help/pro.dart';
import 'package:presentation_master_2/store.dart' as store;

import 'package:url_launcher/url_launcher_string.dart';

import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';




class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HelpScaffold(
            tiles: [
              for (List e in [
                ["Remote Setup", (context) => const WifiSetup()],
                [hasPro ? "Pro Features" : "Get Pro", (context) => const GetProScreen()],
                ["Legal", (context) => const ContactCenter()],
              ]) AppHelpTile(
                onButtonPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: e[1],
                )),
                title: e[0],
              ),
            ],
          ),
          Positioned(
            bottom: MediaQuery.paddingOf(context).bottom + 32,
            width: screenWidth(context),
            child: Column(
              children: [
                Opacity(
                  opacity: 0.5,
                  child: GestureDetector(
                    onDoubleTap: () => showBooleanDialog(
                      context: context,
                      title: "Switch to the ${hasPro ? "Basic" : "Pro"} version?",
                      onYes: () async {
                        await store.changePro(!hasPro);
                        setState(() {});
                      },
                    ),
                    child: FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        return SmallLabel(snapshot.data?.version ?? "© Taavi Rübenhagen 2025");
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




class WifiSetup extends StatelessWidget {
  const WifiSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SizedBox(
        width: screenWidth(context),
        height: screenHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                padding: const EdgeInsets.all(16),
                iconSize: 32,
                color: colorScheme.onBackground,
                icon: const Icon(Icons.arrow_back_outlined),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Heading("Remote setup"),
                  const SizedBox(height: 32),
                  Text(
                    "To turn your phone into a wireless presenter "
                    "(this is not necessary to use the Notes and Timer features), "
                    "you need to download an additional app on your Windows device "
                    "that receives the control signals.\n\n"
                    "Open the website at",
                    style: GoogleFonts.lexend(
                      height: 1.5,
                      fontSize: SmallLabel.textStyle.fontSize,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => showBooleanDialog(
                      title: "Type this URL in the browser on your PC, then read the instructions there.",
                      context: context,
                    ),
                    child: Container(
                      color: colorScheme.primary.withOpacity(0.1),
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      child: FittedBox(
                        child: Text(
                          "pm2app.com",
                          style: GoogleFonts.dmMono(
                            fontSize: LargeLabel.textStyle.fontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "in your PC's browser, download and run the app and follow the instructions there. "
                    "You should then be able to use the remote control.",
                    style: GoogleFonts.lexend(
                      height: 1.5,
                      fontSize: SmallLabel.textStyle.fontSize,
                    ),
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




class ContactCenter extends StatelessWidget {
  const ContactCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      tiles: [
        for (List data in [
          // TODO: Test first
          ["E-Mail me", "mailto:t.ruebenhagen@gmail.com?subject=Feedback for Presentation Master 2"],
          ["Imprint", "https://rubenhagen.com/legal/imprint"],
          ["Privacy Policy", "https://rubenhagen.com/legal/presenter"],
        ]) AppHelpTile(
          link: true,
          onButtonPressed: () => launchUrlString(data[1], mode: LaunchMode.externalApplication),
          title: data[0],
        ),
      ],
    );
  }
}