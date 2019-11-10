import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';

class TextComposerState extends State<TextComposer> {
  static const String photos = "photos";
  final textController = TextEditingController();
  bool isComposing = false;

  void resetController() {
    textController.clear();
    setState(() {
      isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(border: Border(top: BorderSide(color: Colors.grey)))
            : null,
        child: Row(
          children: <Widget>[
            Container(
                child: IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () async {
                    await checkLoggedIn();

                    File imgFile =
                        await ImagePicker.pickImage(source: ImageSource.camera);

                    if (imgFile == null) return;

                    StorageUploadTask storageTask = FirebaseStorage.instance
                        .ref()
                        .child(googleSignIn.currentUser.id.toString() +
                            DateTime.now().millisecondsSinceEpoch.toString())
                        .putFile(imgFile);

                    StorageTaskSnapshot taskSnapshot = await storageTask.onComplete;
                    sendMessage(imgUrl: await taskSnapshot.ref.getDownloadURL());
                  })
            ),
            Expanded(
                child: TextField(
                  controller: textController,
                  decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                    onChanged: (text) {
                      setState(() {
                        isComposing = text.length > 0;
                      });
                    },
                    onSubmitted: (text) {
                      sendTextMessage(text);
                      resetController();
                    },)
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Enviar"),
                        onPressed: isComposing ? () {
                                sendTextMessage(textController.text);
                                resetController();
                              } : null)
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: isComposing ? () {
                                sendTextMessage(textController.text);
                                resetController();
                              } : null)
            )
          ],
        ),
      ),
    );
  }
}
