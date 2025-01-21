// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:presentation_master_2/store.dart' as store;
import 'package:presentation_master_2/main.dart';
import 'package:presentation_master_2/design.dart';

class GetProScreen extends StatefulWidget {
  const GetProScreen({super.key});

  @override
  State<GetProScreen> createState() => _GetProScreenState();
}

class _GetProScreenState extends State<GetProScreen> {
  
  InAppPurchase api = InAppPurchase.instance;

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
              height: screenHeight(context) - 128 - 32,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Heading(hasPro ? "Pro Features" : "Get Pro"),
                  const SizedBox(height: 24),
                  for (List featureData in [
                    [Icons.copy_outlined, "Multiple note sets"],
                    [Icons.timer_outlined, "Presentation timer"],
                    [Icons.text_format_outlined, "Markdown formatting"],
                    [Icons.text_increase_outlined, "Change text size"],
                  ])
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
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
                            LargeLabel(featureData[1]),
                          ],
                        ),
                      ),
                    ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  !true
                  ? AppTextButton(
                    active: !hasPro,
                    onPressed: () async {
                      hasPro = await store.accessProStatus(toggle: true) ?? true;
                      setState(() {});
                    },
                    label: hasPro ? "✓ Unlocked" : "Get for 0.00€",
                  )
                  : FutureBuilder(
                    future: (() async => (await api.queryProductDetails({"pro"})).productDetails.first)(),
                    builder: (context, snapshot) {
                      return AppTextButton(
                        loadingLabel: snapshot.hasData ? null : "Connecting",
                        active: !hasPro,
                        onPressed: () async {
                          if (snapshot.hasData) {
                            api.buyNonConsumable(
                              purchaseParam: PurchaseParam(
                                productDetails: snapshot.data!,
                              ),
                            );
                          }
                          //hasPro = await store.accessProStatus(toggle: true) ?? true;
                          //setState(() {});
                        },
                        label: hasPro ? "✓ Unlocked" : "Get for ${snapshot.data?.price ?? "Loading"}",
                      );
                    }
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
