import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';
import 'package:presentation_master_2/presenter.dart';
import 'package:presentation_master_2/store.dart' as store;
import 'package:presentation_master_2/home.dart';




class HelpScaffold extends StatelessWidget {
  const HelpScaffold({super.key, this.actionButton, this.onBottomButtonPressed, this.bottomButtonLabel, required this.tiles});

  final Widget? actionButton;
  final Function()? onBottomButtonPressed;
  final String? bottomButtonLabel;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorScheme.background,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: onBottomButtonPressed == null || bottomButtonLabel == null ? colorScheme.background : colorScheme.surface,
        ),
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
    this.buttonTitle,
    this.link = false,
    this.content,
  });

  final Function() onButtonPressed;
  final String title;
  final String? buttonTitle;
  final bool link;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: content == null ? 24 : 16),
      child: TextButton(
        onPressed: onButtonPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorScheme.surface),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(content == null ? 16 : 32),
          )),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: SmallHeading(title),
                  ),
                  if (buttonTitle == null) Icon(
                    link ? Icons.open_in_new_outlined : Icons.arrow_forward_ios_outlined,
                    size: 32,
                    color: colorScheme.onSurface.withOpacity(0.5)
                  ),
                ],
              ),
              if (content != null) const SizedBox(height: 32),
              if (content != null) content!,
              if (buttonTitle != null) const SizedBox(height: 32),
              if (buttonTitle != null) AppTextButton(
                onPressed: onButtonPressed,
                label: buttonTitle!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      tiles: [
        for (List e in [
          ["Remote Control", (context) => const WifiSetup()],
          [hasPro ? "Manage Pro" : "Get Pro", (context) => const GetProScreen()],
          ["Support me", (context) => const SupportMeScreen()],
          ["Contact", (context) => const ContactCenter()],
        ]) AppHelpTile(
          onButtonPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: e[1],
          )),
          title: e[0],
        ),
      ],
    );
  }
}




class WifiSetup extends StatefulWidget {
  const WifiSetup({super.key});

  @override
  State<WifiSetup> createState() => _WifiSetupState();
}

class _WifiSetupState extends State<WifiSetup> {
  
  Timer? _connectionStatusTimer;

  final _wifiSetupPageController = PageController();

  @override
  void initState() {
    super.initState();

    _connectionStatusTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(() {}),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _connectionStatusTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorScheme.surface,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: colorScheme.surface,
        ),
        toolbarHeight: 96,
        leadingWidth: 96,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.all(16),
          iconSize: 32,
          color: colorScheme.onSurface,
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: PageView.builder(
        controller: _wifiSetupPageController,
        itemCount: 2,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, bottom: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 32),
                    children: [
                      MediumLabel(
                        i == 1
                        ? '1. Whenever you want to present, connect both devices to the same WiFi.\n\n2. Open both apps. Tap the big play button in the mobile app to turn on presentation mode.\n\n3. Open a PowerPoint presentation on your PC and wait for the mobile app to connect.'
                        : "To make this app work as a remote control for your PowerPoint presentation, open the link",
                      ),
                      if (i == 0) Container(
                        margin: const EdgeInsets.symmetric(vertical: 48),
                        alignment: Alignment.center,
                        child: LargeLabel("presenter.onrender.com"),
                      ),
                      if (i == 0) MediumLabel(
                        "in your PC's (!) browser and follow the instructions exactly to install the PC app that receives the controlling signals.\n\nAlternatively, you can just add speaker notes and use the app only as note card/timer replacement.",
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onDoubleTap: () async => showBooleanDialog(
                        context: context,
                        title: "Detected IP address: $serverIP\nIP address of this device: ${await NetworkInfo().getWifiIP()}",
                      ),
                      child: AppTextButton(
                        onPressed: () => i == 1
                        ? serverIP == null
                          ? showBooleanDialog(
                            context: context,
                            title: "Wait for your devices to connect, or go back and add speaker notes.",
                          )
                          : navigateToAvailablePresenter(context)
                        : _wifiSetupPageController.nextPage(duration: const Duration(milliseconds: 400), curve: appDefaultCurve),
                        loading: i != 0 && serverIP == null,
                        next: i == 0,
                        label: i == 1
                        ? serverIP == null ? "Scanning..." : "Try presenting"
                        : "Next",
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextButton(
                      onPressed: () {
                        if (i == 1) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Home(editing: true),
                        ));
                      },
                      secondary: true,
                      label: i == 1 ? "Close" : "Edit notes",
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}




class GetProScreen extends StatefulWidget {
  const GetProScreen({super.key});

  @override
  State<GetProScreen> createState() => _GetProScreenState();
}

class _GetProScreenState extends State<GetProScreen> {
  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      tiles: [
        AppHelpTile(
          title: "Get Pro",
          onButtonPressed: true
          ? () async {
            hasPro = await store.accessProStatus(toggle: true) ?? true;
            setState(() {});
          }
          // TODO: 18: Implement purchase using in_app_purchase (enable in 18 store accounts); Remove all old code
          : () {},
          buttonTitle: true ? hasPro ? "Return to basic" : "Unlock for free" : "Buy Pro for 4.99€",
          content: Column(
            children: [
              for (List featureData in [
                  [Icons.timer_outlined, "Presentation timer"],
                  [Icons.copy_outlined, "Multiple presentation notes"],
                  [Icons.text_format_outlined, "Markdown formatting"],
              ]) Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: SizedBox(
                  width: screenWidth(context) - 32 - 32,
                  child: Row(
                    children: [
                      Icon(
                        featureData[0],
                        size: 32,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(width: 32),
                      Flexible(
                        child: MediumLabel(featureData[1]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




class SupportMeScreen extends StatelessWidget {
  const SupportMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      tiles: [
        AppHelpTile(
          onButtonPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => FeedbackScreen(),
          )),
          title: "Give Feedback",
        ),
        AppHelpTile(
          onButtonPressed: () {
            try {
              InAppReview.instance.requestReview();
            } finally {
              launchUrlString("https://play.google.com/store/apps/details?id=tavy.presenter.presentation_master_2", mode: LaunchMode.externalApplication);
            }
          },
          title: "Rate the app",
          link: true
        ),
        AppHelpTile(
          onButtonPressed: () => launchUrlString("https://www.buymeacoffee.com/taavirubenhagen", mode: LaunchMode.externalApplication),
          title: "Buy me a coffee",
          link: true
        ),
      ],
    );
  }
}




class ContactCenter extends StatelessWidget {
  const ContactCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      tiles: [
        AppHelpTile(
          onButtonPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => FeedbackScreen(),
          )),
          title: "Feedback",
        ),
        AppHelpTile(
          onButtonPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => const ContactScreen(),
          )),
          title: "Contact",
        ),
        // TODO: 18: Change URL
        AppHelpTile(
          onButtonPressed: () => launchUrlString("https://taavirubenhagen.netlify.app/main/presenter/privacy-policy", mode: LaunchMode.externalApplication),
          title: "Privacy Policy",
          link: true
        ),
      ],
    );
  }
}




// ignore: must_be_immutable
class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  String feedback = "";

  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      actionButton: AppTextButton(
        onPressed: () async {
          launchUrlString("mailto:taavi.ruebenhagen@gmail.com?subject=Feedback for Presentation Master 2&body=$feedback");
          Navigator.pop(context);
          showBooleanDialog(
            context: context,
            title: "Your feedback has been processed.",
          );
        },
        onBackground: true,
        label: "Send",
        isLink: true,
      ),
      tiles: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: TextFormField(
            onChanged: (value) => feedback = value,
            keyboardAppearance: Brightness.dark,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            minLines: null,
            maxLines: null,
            cursorRadius: const Radius.circular(16),
            cursorColor: colorScheme.onSurface,
            style: MainText.textStyle,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintMaxLines: 5,
              hintText: "Enter your feedback and mention whether or not you want a response.",
            ),
          ),
        ),
      ],
    );
  }
}




class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      onBottomButtonPressed: () => launchUrlString("mailto:tavyai.apps@gmail.com"),
      bottomButtonLabel: "E-Mail me",
      tiles: [
        for (String line in true
        ? [
          "René Rübenhagen",
          "Kastanienallee 22, 23562 Lübeck, Germany",
          "tavyai.apps@gmail.com",
        ]
        : [
          "Taavi Rübenhagen",
          "Pothof 9d, 38122 Braunschweig, Germany",
          "taavi.ruebenhagen@gmail.com",
        ]) Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colorScheme.surface,
          ),
          child: MediumLabel(line),
        ),
      ],
    );
  }
}