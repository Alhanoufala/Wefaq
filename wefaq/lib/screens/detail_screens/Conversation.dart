import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import 'package:flutter/material.dart';

class Conversation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, int index) {
          final message = messages[index];
          bool isMe = message.sender.id == currentUser.id;
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isMe)
                      CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            AssetImage('assets/images/PlaceHolder.png'),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      decoration: BoxDecoration(
                          color: isMe
                              ? Colors.grey[200]
                              : Color.fromARGB(255, 178, 195, 202),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 12 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 12),
                          )),
                      child: Text(
                        "Name \n" + messages[index].text,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    if (isMe)
                      CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            AssetImage('assets/images/PlaceHolder.png'),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isMe)
                        SizedBox(
                          width: 40,
                        ),
                      Icon(
                        Icons.done_all,
                        size: 20,
                        color: Color.fromARGB(255, 145, 124, 178),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      // Text(
                      //   // "Name | ",
                      // ),
                      Text(
                        message.time,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
