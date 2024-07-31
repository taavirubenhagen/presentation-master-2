// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';
import 'package:presentation_master_2/presenter.dart';
import 'package:presentation_master_2/store.dart' as store;
import 'package:presentation_master_2/home.dart';
import 'package:presentation_master_2/mockups.dart';




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
          color: colorScheme.onBackground,
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: PageView.builder(
        controller: _wifiSetupPageController,
        itemCount: 4,
        itemBuilder: (context, i) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: screenHeight(context),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                      right: 32,
                      bottom: 64 + AppTextButton.defaultHeight + 16 + AppTextButton.defaultHeight + 16 + 56,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight(context) * ( i == 1 ? 0.3 : 0.35 ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              [
                                const OnboardingMockupIllustration(),
                                GestureDetector(
                                  onTap: () => showBooleanDialog(
                                    title: "Type this URL in the browser on your PC, then read the instructions there.",
                                    context: context,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(color: colorScheme.onSurface),
                                      color: colorScheme.primary,
                                    ),
                                    height: 64,
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      child: LargeLabel(
                                        "presenter.onrender.com",
                                        onPrimary: true,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(width: laptopWidth(context) / 3),
                                        Expanded(
                                          child: Container(
                                            height: 64,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(color: colorScheme.onSurface),
                                                top: BorderSide(color: colorScheme.onSurface),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 64 - 48 / 2),
                                          child: Icon(
                                            Icons.wifi_outlined,
                                            size: 48,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 64,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(color: colorScheme.onSurface),
                                                top: BorderSide(color: colorScheme.onSurface),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: laptopWidth(context) / 3),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: laptopWidth(context) / 3 - phoneWidth(context) / 2),
                                          child: Transform.scale(
                                            scale: 0.75,
                                            child: const PhoneFrame(
                                              laptopPadding: false,
                                              child: NotePresenterMockup(),
                                            ),
                                          ),
                                        ),
                                        Transform.scale(
                                          scale: 0.75,
                                          child: LaptopFrame(
                                            phonePadding: false,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: laptopWidth(context) / 8,
                                                  top: laptopWidth(context) / 12,
                                                  child: Container(
                                                    width: laptopWidth(context) / 3,
                                                    height: laptopWidth(context) * 9/16 / 3,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(2),
                                                      border: Border(
                                                        left: BorderSide(color: colorScheme.onBackground),
                                                        right: BorderSide(color: colorScheme.onBackground),
                                                        top: BorderSide(
                                                          width: 4,
                                                          color: colorScheme.onBackground,
                                                        ),
                                                        bottom: BorderSide(color: colorScheme.onBackground),
                                                      ),
                                                      color: colorScheme.surface,
                                                    ),
                                                    child: const PresentationMaster2ForPCMockup(),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: laptopWidth(context) / 12,
                                                  bottom: laptopWidth(context) / 16,
                                                  child: Transform.scale(
                                                    scale: 1/2,
                                                    alignment: Alignment.bottomRight,
                                                    child: Container(
                                                      width: laptopWidth(context),
                                                      height: laptopWidth(context) * 9/16,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(4),
                                                        border: Border(
                                                          left: BorderSide(
                                                            width: 2,
                                                            color: colorScheme.onBackground,
                                                          ),
                                                          right: BorderSide(
                                                            width: 2,
                                                            color: colorScheme.onBackground,
                                                          ),
                                                          top: BorderSide(
                                                            width: 8,
                                                            color: colorScheme.onBackground,
                                                          ),
                                                          bottom: BorderSide(
                                                            width: 2,
                                                            color: colorScheme.onBackground,
                                                          ),
                                                        ),
                                                        color: colorScheme.surface,
                                                      ),
                                                      child: const ExamplePresentationMockup(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 2,
                                  child: const PhoneFrame(
                                    laptopPadding: false,
                                    child: HomeMockup(),
                                  ),
                                ),
                              ][i],
                            ],
                          ),
                        ),
                        MediumLabel(
                          [
                            'Turn your phone into a remote control for presentations '
                            'on your Windows PC/laptop (tablet is not supported). Alternatively, keep using this app as a note card replacement.',
                  
                            'You need an additional app on your PC to receive the controlling signals.\n\n'
                            "Open the link above in your PCs (!) browser and follow the instructions exactly.",
                  
                            'Whenever you want to present, connect both devices to the same WiFi, start the Windows app and open a presentation on your PC.',
                  
                            'Tap the big play button in the mobile app. As soon as a connection is established, you can control the presentation with your phone.',
                          ][i],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: screenWidth(context) - 2 * 32 + 2 * 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTextButton.defaultBorderRadius + 16 / 2),
                  child: Padding(
                    padding: const EdgeInsets.all(16).copyWith(bottom: 64),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2,
                        sigmaY: 2,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onDoubleTap: () async => showBooleanDialog(
                              // ignore: use_build_context_synchronously
                              context: context,
                              title: "Detected IP address: $serverIP\nIP address of this device: ${await NetworkInfo().getWifiIP()}",
                            ),
                            child: AppTextButton(
                              onPressed: () => i == 3
                              ? serverIP == null
                                ? showBooleanDialog(
                                  context: context,
                                  title: "Wait for your devices to connect, or go back and add speaker notes.",
                                )
                                : navigateToAvailablePresenter(context)
                              : _wifiSetupPageController.nextPage(duration: const Duration(milliseconds: 400), curve: appDefaultCurve),
                              loadingLabel: i == 3 && serverIP == null ? '' : null,
                              next: i != 3,
                              label: i == 3
                              ? serverIP == null ? "Scanning..." : "Try presenting"
                              : "Next",
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextButton(
                            onPressed: () {
                              if (i != 0) {
                                Navigator.pop(context);
                                if (!onboarding) {
                                  Navigator.pop(context);
                                }
                                return;
                              }
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const Home(editing: true),
                              ));
                            },
                            secondary: true,
                            label: i != 0 ? ( i == 3 ? 'Close' : 'Cancel' ) : 'Edit notes',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                        child: MediumLabel(
                          featureData[1],
                          justify: false,
                        ),
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
        FutureBuilder(
          future: (() async => ( await PackageInfo.fromPlatform() ).installerStore)(),
          builder: (context, snapshot) => Platform.isAndroid
          ? AppHelpTile(
            onButtonPressed: () => launchUrlString("https://www.buymeacoffee.com/taavirubenhagen", mode: LaunchMode.externalApplication),
            title: "Buy me a coffee",
            link: true
          )
          : const SizedBox(),
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
        // TODO: Change URL
        AppHelpTile(
          onButtonPressed: () => launchUrlString("https://rubenhagen.com/presenter/privacy-policy", mode: LaunchMode.externalApplication),
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
      onBottomButtonPressed: () => launchUrlString("mailto:taavi.ruebenhagen@gmail.com"),
      bottomButtonIsLink: true,
      bottomButtonLabel: "E-Mail me",
      tiles: [
        for (String line in [
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
          child: MediumLabel(
            line,
            justify: false,
          ),
        ),
      ],
    );
  }
}