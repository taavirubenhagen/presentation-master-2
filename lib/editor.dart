import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

import 'package:presenter_2/design.dart';
import 'package:presenter_2/main.dart';




class NoteEditor extends StatefulWidget {
  const NoteEditor({required this.presentationIndex, super.key});

  final int presentationIndex;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(
          Icons.check_outlined,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 96,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_outlined),
                    ),
                    const SizedBox(width: 16),
                    LargeHeading("Notes of"),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(),
                      ),
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SmallLabel("Presentation 1"),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_drop_down_outlined,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //const SizedBox(height: 16),
            Divider(),
            Expanded(
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16).copyWith(top: 32),
                    child: MarkdownParse(
                      styleSheet: MarkdownStyleSheet(
                        p: MainText.textStyle,
                        a: MainText.textStyle.copyWith(color: Colors.blue),
                        h1: LargeHeading.textStyle,
                        h2: MediumHeading.textStyle,
                        h3: SmallHeading.textStyle,
                      ),
                      data: "dfasfsdf",
                    ),
                  ),
                  MarkdownField(
                    controller: TextEditingController(),
                    expands: true,
                    padding: const EdgeInsets.all(16).copyWith(top: 32),
                    style: MainText.textStyle,
                    decoration: InputDecoration.collapsed(
                      hintText: "Speaker notes go here. Supports markdown.",
                      hintStyle: MainText.textStyle.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
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