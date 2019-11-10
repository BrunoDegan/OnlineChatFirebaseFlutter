import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


const String sender_url = "senderPhotoUrl";
const String text = "text";
const String sender_name = "senderName";
const String img_url = 'imgUrl';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;

  ChatMessage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data[sender_url]),
            ),
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(data[sender_name],
                  style: Theme.of(context).textTheme.subhead),
              Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: data[img_url] != null
                      ? Image.network(data[img_url], width: 250.0)
                      : Text(data[text]))

            ],
          ))
        ],
      ),
    );
  }
}
