
import 'package:chatonlinefirebaseflutter/textcomposerstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'chatscreenstate.dart';

const String messages = "messages";
const String users = "users";

final googleSignIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

final ThemeData kIOStheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = ThemeData(
    primarySwatch: Colors.purple,
    accentColor: Colors.orangeAccent[400]);

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App Online",
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kIOStheme
          : kDefaultTheme,
      home: ChatOnlineScreen(),
    );
  }
}

class ChatOnlineScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class TextComposer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TextComposerState();
}

Future<Null> checkLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;

  if (user == null) {
    user = await googleSignIn.signInSilently();
  }

  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken);

    await auth.signInWithCredential(credential);
  }
}

void sendTextMessage(String msg) async {
  await checkLoggedIn();
  sendMessage(text: msg);
}

void sendMessage({String text, String imgUrl}){
  Firestore.instance.collection(messages).add(
      {
        "text" : text,
        "imgUrl" : imgUrl,
        "senderName" : googleSignIn.currentUser.displayName,
        "senderPhotoUrl" : googleSignIn.currentUser.photoUrl,
        "senderTime" : new DateTime.now()
      }
  );
}


