import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher_string.dart';

import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';
import 'package:presentation_master_2/presenter.dart';
import 'package:presentation_master_2/store.dart' as store;
import 'package:presentation_master_2/home.dart';




class HelpScaffold extends StatelessWidget {
  const HelpScaffold({super.key, required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorScheme.background,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: colorScheme.background,
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
      ),
      body: Column(
        children: tiles,
      ),
    );
  }
}




class AppHelpTile extends StatelessWidget {
  const AppHelpTile({
    super.key,
    this.onButtonPressed,
    required this.title,
    this.tappableIconData,
    this.buttonTitle,
    this.isButtonExternalLink = false,
    this.content,
  });

  final Function()? onButtonPressed;
  final String title;
  final IconData? tappableIconData;
  final String? buttonTitle;
  final bool isButtonExternalLink;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
      child: TextButton(
        onPressed: onButtonPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorScheme.surface),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          )),
        ),
        child: Container(
          width: screenWidth(context) - 32,
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
                  Icon(
                    tappableIconData,
                    size: 32,
                    color: colorScheme.onSurface.withOpacity(0.5)
                  ),
                ],
              ),
              if (content != null) const SizedBox(height: 32),
              if (content != null) content!,
              if (tappableIconData == null && buttonTitle != null && onButtonPressed != null) const SizedBox(height: 32),
              if (tappableIconData == null && buttonTitle != null && onButtonPressed != null) AppTextButton(
                onPressed: onButtonPressed!,
                isLink: isButtonExternalLink,
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
  const HelpCenter({super.key, required this.presentationData});

  final Map<String, dynamic>? presentationData;

  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      tiles: [
        AppHelpTile(
          onButtonPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => WifiSetup(presentationData: presentationData),
          )),
          title: "Connect Remote",
          tappableIconData: Icons.arrow_forward_ios_outlined,
        ),
        AppHelpTile(
          onButtonPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => WifiSetup(
              use: true,
              presentationData: presentationData,
            ),
          )),
          title: "Use Remote",
          tappableIconData: Icons.arrow_forward_ios_outlined,
        ),
        AppHelpTile(
          onButtonPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => const GetUltraScreen(),
          )),
          title: hasUltra ? "Manage Ultra" : "Get Ultra",
          tappableIconData: Icons.arrow_forward_ios_outlined,
        ),
        AppHelpTile(
          onButtonPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => const ContactScreen(),
          )),
          title: "Contact",
          tappableIconData: Icons.arrow_forward_ios_outlined,
        ),
      ],
    );
  }
}




class WifiSetupScaffold extends StatelessWidget {
  const WifiSetupScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPrimaryButtonPressed,
    required this.primaryButtonLabel,
    this.onSecondaryButtonPressed,
    this.secondaryButtonLabel,
    required this.illustrationImage
  });

  final String title;
  final  String subtitle;
  final Function() onPrimaryButtonPressed;
  final String primaryButtonLabel;
  final Function()? onSecondaryButtonPressed;
  final String? secondaryButtonLabel;
  final Widget illustrationImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32).copyWith(bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Placeholder(
            child: SizedBox(
              width: screenWidth(context) / 3,
              height: screenWidth(context) / 3,
              child: illustrationImage,
            ),
          ),
          Column(
            children: [
              MediumHeading(title),
              const SizedBox(height: 32),
              MediumLabel(subtitle),
            ],
          ),
          Column(
            children: [
              AppTextButton(
                onPressed: onPrimaryButtonPressed,
                label: primaryButtonLabel,
              ),
              if (secondaryButtonLabel != null && onSecondaryButtonPressed != null) const SizedBox(height: 16),
              if (secondaryButtonLabel != null && onSecondaryButtonPressed != null) AppTextButton(
                onPressed: onSecondaryButtonPressed!,
                secondary: true,
                label: secondaryButtonLabel!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// TODO: 18
class WifiSetup extends StatefulWidget {
  const WifiSetup({super.key, this.use = false, required this.presentationData});

  final bool use;
  final Map<String, dynamic>? presentationData;

  @override
  State<WifiSetup> createState() => _WifiSetupState();
}

class _WifiSetupState extends State<WifiSetup> {

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
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  MediumHeading(widget.use ? "Using the remote control" : "Set up remote control"),
                  const SizedBox(height: 32),
                  MediumLabel(
                    widget.use
                    ? '1. Make sure to follow the "Connect Remote" instructions in the help center first, then connect both devices to the same WiFi.\n\n2. Open both apps. Tap the play button in the mobile app to turn on presentation mode.\n\n3. Open a PowerPoint on your PC and wait for the mobile app to connect.'
                    : "Watch a short video to learn how to download the PC app that receives the signals of the remote control.\n\nAlternatively, you can just add speaker notes and use the app only as note card replacement.",
                  ),
                ],
              ),
            ),
            Column(
              children: [
                AppTextButton(
                  onPressed: () => widget.use
                  ? navigateToAvailablePresenter(context, widget.presentationData)
                  : launchUrlString(
                    "https://youtu.be/zjYiOR03C8M",
                    mode: LaunchMode.externalApplication,
                  ),
                  isActive: !widget.use || serverIP != null,
                  isLink: !widget.use,
                  label: widget.use
                  ? serverIP == null ? "Scanning..." : "Try presenting"
                  : "Watch video",
                ),
                const SizedBox(height: 16),
                AppTextButton(
                  onPressed: () => widget.use
                  ? Navigator.pop(context)
                  : Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Home(editing: true),
                  )),
                  secondary: true,
                  label: widget.use ? "Close" : "Edit notes",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      // TODO: 18
      tiles: [
        AppHelpTile(
          onButtonPressed: () => launchUrlString("mailto:tavyai.apps@gmail.com", mode: LaunchMode.externalApplication),
          title: "Feedback",
          tappableIconData: Icons.open_in_new_outlined,
        ),
        AppHelpTile(
          onButtonPressed: () => launchUrlString("https://taavirubenhagen.netlify.app/main/contact", mode: LaunchMode.externalApplication),
          title: "Contact",
          tappableIconData: Icons.open_in_new_outlined,
        ),
        AppHelpTile(
          onButtonPressed: () => launchUrlString("https://taavirubenhagen.netlify.app/main/presenter/privacy-policy", mode: LaunchMode.externalApplication),
          title: "Privacy Policy",
          tappableIconData: Icons.open_in_new_outlined,
        ),
      ],
    );
  }
}




class GetUltraScreen extends StatefulWidget {
  const GetUltraScreen({super.key});

  @override
  State<GetUltraScreen> createState() => _GetUltraScreenState();
}

class _GetUltraScreenState extends State<GetUltraScreen> {
  @override
  Widget build(BuildContext context) {
    return HelpScaffold(
      tiles: [
        AppHelpTile(
          title: "Get Ultra",
          onButtonPressed: () async {
            hasUltra = await store.accessUltraStatus(toggle: true) ?? true;
            setState(() {});
          },
          // TODO: 18
          buttonTitle: hasUltra ? "Return to basic" : "Unlock for free",
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