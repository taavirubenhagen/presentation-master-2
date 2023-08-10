/// THIS FILE IS CRITICAL FOR STORING USER-GENERATED DATA.
/// ANY CHANGES MAY LEAD TO BACKWARDS COMPATIBILITY ISSUES.
/// IMPORT ONLY WITH THE ALIAS ```store```.
// Use lowercase for JSON keys.

import 'dart:convert';

import 'package:presentation_master_2/main.dart';
import 'package:shared_preferences/shared_preferences.dart';




typedef Presentations = List<Map<String, dynamic>>;

const presentationNameKey = "name";
const presentationNotesKey = "speakernotes";
const presentationMinutesKey = "timerminutes";

const _presentationsKey = "presentations";
const _ultraStatusKey = "ultrastatus";




Future<Presentations> accessPresentations({Presentations add = const [], Presentations remove = const []}) async {

  final SharedPreferences _instance = await SharedPreferences.getInstance();

  Presentations _presentations = [
    {
      presentationNameKey: "Presentation",
      presentationNotesKey: "",
      presentationMinutesKey: 0,
    },
  ];
  final _rawData = json.decode(_instance.getString(_presentationsKey) ?? json.encode(_presentations));
  if (_rawData.runtimeType == List) {
    _presentations = Presentations.from(_rawData);
  }

  for (Map<String, dynamic> p in remove + add) {
    _presentations.removeWhere((Map<String, dynamic> e) => e[presentationNameKey] == p[presentationNameKey]);
  }
  for (Map<String, dynamic> p in add) {
    _presentations.add(p);
  }
  await _instance.setString(
    _presentationsKey,
    json.encode(
      _presentations,
    )
  );

  globalPresentations = _presentations;
  return globalPresentations ?? _presentations;
}

Future<Map<String, dynamic>> mutatePresentation({
  required Map<String, dynamic>? oldPresentation,
  String? name,
  bool isDeleting = false,
  String? speakerNotes,
  bool? isTimerActive,
  int? timerMinutes,
  List<int>? vibratingMinutes,
}) async {
  Map<String, dynamic> _newPresentation = {
    presentationNameKey: oldPresentation?[presentationNameKey] ?? name ?? "Presentation",
    presentationNotesKey: speakerNotes ?? oldPresentation?[presentationNotesKey] ?? "",
    presentationMinutesKey: timerMinutes ?? oldPresentation?[presentationMinutesKey] ?? 0,
  };
  return isDeleting
  ? ( await accessPresentations(add: [], remove: [_newPresentation]) ).first
  : ( await accessPresentations(add: [_newPresentation], remove: []) ).firstWhere((Map<String, dynamic> e) => e[presentationNameKey] == _newPresentation[presentationNameKey]);
}

presentationAvailable(Map<String, dynamic>? presentation) => ( presentation?[presentationNotesKey] ?? "" ) != "" || ( presentation?[presentationMinutesKey] ?? 0 ) != 0;




Future<bool?> accessUltraStatus({final bool toggle = false}) async {
  final SharedPreferences _instance = await SharedPreferences.getInstance();
  if (toggle) {
    _instance.setBool(_ultraStatusKey, !( await accessUltraStatus() ?? true ));
  }
  return _instance.getBool(_ultraStatusKey);
}