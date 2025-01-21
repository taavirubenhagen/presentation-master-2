import 'dart:convert';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:presentation_master_2/main.dart';
import 'package:shared_preferences/shared_preferences.dart';




typedef Presentations = List<Map<String, dynamic>>;

const presentationNameKey = "name";
const presentationNotesKey = "speakernotes";
const presentationMinutesKey = "timerminutes";

const _presentationsKey = "presentations";
const _proStatusKey = "prostatus";




Future<Presentations> accessPresentations({Presentations add = const [], Presentations remove = const []}) async {

  final SharedPreferences instance = await SharedPreferences.getInstance();

  Presentations presentations = [
    {
      presentationNameKey: "Presentation 1",
      presentationNotesKey: "",
      presentationMinutesKey: 0,
    },
  ];
  final rawData = json.decode(instance.getString(_presentationsKey) ?? json.encode(presentations));
  if (rawData.runtimeType == List) {
    presentations = Presentations.from(rawData);
  }

  for (Map<String, dynamic> p in remove + add) {
    presentations.removeWhere((Map<String, dynamic> e) => e[presentationNameKey] == p[presentationNameKey]);
  }
  for (Map<String, dynamic> p in add) { presentations.add(p); }
  await instance.setString(
    _presentationsKey,
    json.encode(presentations),
  );

  globalPresentations = presentations;
  return globalPresentations ?? presentations;
}

Future<Map<String, dynamic>> mutatePresentation({
  required Map<String, dynamic>? oldPresentation,
  String? name,
  bool isDeleting = false,
  String? speakerNotes,
  int? timerMinutes,
}) async {
  Map<String, dynamic> newPresentation = {
    presentationNameKey: oldPresentation?[presentationNameKey] ?? name ?? "Presentation 1",
    presentationNotesKey: speakerNotes ?? oldPresentation?[presentationNotesKey] ?? "",
    presentationMinutesKey: timerMinutes ?? oldPresentation?[presentationMinutesKey] ?? 0,
  };
  return isDeleting
  ? ( await accessPresentations(add: [], remove: [newPresentation]) ).first
  : ( await accessPresentations(add: [newPresentation], remove: []) ).firstWhere((Map<String, dynamic> e) => e[presentationNameKey] == newPresentation[presentationNameKey]);
}

presentationAvailable(Map<String, dynamic>? presentation) => ( presentation?[presentationNotesKey] ?? "" ) != "" || ( presentation?[presentationMinutesKey] ?? 0 ) != 0;




// TODO: R
Future<bool?> accessProStatus({final bool toggle = false}) async {
  final SharedPreferences instance = await SharedPreferences.getInstance();
  if (toggle) {
    instance.setBool(_proStatusKey, !( await accessProStatus() ?? true ));
  }
  try {
    return instance.getBool(_proStatusKey);
  } catch (e) {
    return null;
  }
}




Future<void> accessPro(final bool? x) async {
  final SharedPreferences instance = await SharedPreferences.getInstance();
  InAppPurchase api = InAppPurchase.instance;
  
  if (x != null) {
    instance.setBool(_proStatusKey, !( await accessProStatus() ?? true ));
  }
  hasPro = instance.getBool(_proStatusKey) ?? true;
  
  await api.restorePurchases();
  api.purchaseStream.listen(
    (details) async {
      if (
        details.last.pendingCompletePurchase ||
        details.last.status == PurchaseStatus.purchased ||
        details.last.status == PurchaseStatus.restored
      ) {
        if (details.last.pendingCompletePurchase) {
          api.completePurchase(details.first);
        }
        hasPro = true;
      }
    },
  );
}