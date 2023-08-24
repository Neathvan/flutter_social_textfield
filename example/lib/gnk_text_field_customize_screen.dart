import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_social_textfield/controller/social_text_editing_controller.dart';
import 'package:flutter_social_textfield/model/detected_type_enum.dart';
import 'package:flutter_social_textfield/model/social_content_detection_model.dart';
import 'package:flutter_social_textfield/widget/social_text_field_controller.dart';

class GnkTextFieldCustomizeScreen extends StatefulWidget {
  const GnkTextFieldCustomizeScreen({Key? key}) : super(key: key);

  @override
  _GnkTextFieldCustomizeScreenState createState() =>
      _GnkTextFieldCustomizeScreenState();
}

class _GnkTextFieldCustomizeScreenState
    extends State<GnkTextFieldCustomizeScreen> {
  late final SocialTextEditingController _textEditingController;
  late final TextRange lastDetectedRange;

  bool isSelectorOpen = false;
  FocusNode _focusNode = FocusNode();
  ScrollController _scrollController = ScrollController();

  SocialContentDetection lastDetection =
      SocialContentDetection(DetectedType.plain_text, TextRange.empty, "");

  late final StreamSubscription<SocialContentDetection> _streamSubscription;

  @override
  void dispose() {
    _focusNode.dispose();
    _streamSubscription.cancel();
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = SocialTextEditingController()
      ..text = ""
      ..setTextStyle(
          DetectedType.mention,
          TextStyle(
              color: Colors.purple,
              backgroundColor: Colors.purple.withAlpha(50)))
      ..setTextStyle(DetectedType.url,
          TextStyle(color: Colors.blue, decoration: TextDecoration.underline))
      ..setTextStyle(DetectedType.hashtag,
          TextStyle(color: Colors.blue, fontWeight: FontWeight.w600));

    _streamSubscription =
        _textEditingController.subscribeToDetection(onDetectContent);
  }

  void onDetectContent(SocialContentDetection detection) {
    lastDetection = detection;
  }

  List<String> mentionUser = [];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.4;
    return Scaffold(
      appBar: AppBar(
        title: Text("MY CUSTOMIZE"),
      ),
      body: Column(
        children: [
          Text(_textEditingController.mentionHandleNames.toString()),
          Expanded(
            child: DefaultSocialTextFieldController(
              detectionPresentationMode: DetectionPresentationMode.split_screen,
              focusNode: _focusNode,
              scrollController: _scrollController,
              textEditingController: _textEditingController,
              child: Container(
                padding: EdgeInsets.all(8),
                child: TextField(
                  scrollPhysics: ClampingScrollPhysics(),
                  scrollController: _scrollController,
                  focusNode: _focusNode,
                  autofocus: true,
                  controller: _textEditingController,
                  onChanged: (value) {
                    // _textEditingController.mentionHandleName.addAll(["Text"]);

                    // setState(() {
                    //   mentionUser = _textEditingController.mentionHandleName;
                    // });
                  },
                  maxLines: null,
                  minLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    hintText: "Type your message",
                  ),
                ),
              ),
              detectionBuilders: {
                DetectedType.mention: (context) => mentionContent(height),
                DetectedType.hashtag: (context) => hashtagContent(height),
                // DetectedType.url: (context) => urlContent(height)
              },
            ),
          ),
          // bar
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // tag
                  Icon(Icons.production_quantity_limits),
                  const Spacer(),
                  // upload image
                  Icon(Icons.production_quantity_limits),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  PreferredSize mentionContent(double height) {
    return PreferredSize(
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, -8), color: Colors.black12, blurRadius: 4)
            ]),
        child: ListView.builder(
            itemBuilder: (context, index) => ListTile(
                  title: Text("@user_$index"),
                  onTap: () {
                    _textEditingController.replaceRange(
                        "@user_$index", lastDetection.range);
                    // _textEditingController.setMentionHandleNames =
                    //     'user_$index';

                    setState(() {
                      _textEditingController.mentionHandleNames
                          .add('user_$index');
                    });
                  },
                )),
      ),
      preferredSize: Size.fromHeight(height),
    );
  }

  PreferredSize hashtagContent(double height) {
    return PreferredSize(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, -8), color: Colors.black12, blurRadius: 4)
            ]),
        child: ListView.builder(
            itemBuilder: (context, index) => ListTile(
                  title: Text("#hashtag_$index"),
                  onTap: () {
                    _textEditingController.replaceRange(
                        "#hashtag_$index", lastDetection.range);
                  },
                )),
      ),
      preferredSize: Size.fromHeight(height),
    );
  }

  PreferredSize urlContent(double height) {
    return PreferredSize(
      child: Container(
        alignment: Alignment.center,
        child: Text("A Website for url content"),
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, -8), color: Colors.black12, blurRadius: 4)
            ]),
      ),
      preferredSize: Size.fromHeight(height),
    );
  }
}
