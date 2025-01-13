// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presentation_master_2/store.dart' as store;

import 'package:url_launcher/url_launcher_string.dart';

import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';




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
        // TODO: s Play Store
        /*systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorScheme.background,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: onBottomButtonPressed == null || bottomButtonLabel == null ? colorScheme.background : colorScheme.surface,
        ),*/
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
    this.onButtonPressed,
    required this.title,
    this.buttonTitle,
    this.link = false,
    this.content,
  });

  final Function()? onButtonPressed;
  final String title;
  final String? buttonTitle;
  final bool link;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: content == null ? 24 : 16),
      child: TextButton(
        onPressed: onButtonPressed ?? () {},
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
                    child: LargeLabel(title),
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
                onPressed: onButtonPressed ?? () {},
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
                          "presenter.onrender.com",
                          style: GoogleFonts.dmMono(
                            fontSize: MediumLabel.textStyle.fontSize,
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




class GetProScreen extends StatefulWidget {
  const GetProScreen({super.key});

  @override
  State<GetProScreen> createState() => _GetProScreenState();
}

class _GetProScreenState extends State<GetProScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
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
            child: SizedBox(
              height: screenHeight(context) - 128 - 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Heading(hasPro ? "Pro Features" : "Get Pro"),
                  const SizedBox(height: 32),
                  for (List featureData in [
                      [Icons.copy_outlined, "Multiple note sets"],
                      [Icons.timer_outlined, "Presentation timer"],
                      [Icons.text_format_outlined, "Markdown formatting"],
                      [Icons.text_increase_outlined, "Change text size"],
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
                  const Expanded(
                    child: SizedBox(),
                  ),
                  AppTextButton(
                    onPressed: () => setState(() async => hasPro = await store.accessProStatus(toggle: true) ?? true),
                    label: hasPro ? "✓ Unlocked" : true ? "Unlock for free" : "Buy for 8.99€",
                  ),
                ],
              ),
            ),
          ),
        ],
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
        AppHelpTile(
          link: true,
          onButtonPressed: () => launchUrlString("mailto:t.ruebenhagen@gmail.com?subject=Feedback for Presentation Master 2"),
          title: "E-Mail me",
        ),
        AppHelpTile(
          link: true,
          onButtonPressed: () => launchUrlString("https://rubenhagen.com/legal/imprint", mode: LaunchMode.externalApplication),
          title: "Imprint",
        ),
        AppHelpTile(
          onButtonPressed: () => launchUrlString("https://rubenhagen.com/legal/presenter", mode: LaunchMode.externalApplication),
          title: "Privacy Policy",
          link: true
        ),
      ],
    );
  }
}