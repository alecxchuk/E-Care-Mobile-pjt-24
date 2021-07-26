import 'package:e_care_mobile/chat/api/chat_api.dart';
import 'package:e_care_mobile/chat/models/chatMessageModel.dart';
import 'package:e_care_mobile/providers/chat_provider.dart';
import 'package:e_care_mobile/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  final int index;
  final ChatMessage message;
  final bool isMe;
  final String time;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool isSelected;

  const MessageWidget(
      {@required this.index,
      @required this.message,
      @required this.isMe,
      @required this.time,
      @required this.onLongPress,
      @required this.onTap,
      @required this.isSelected});

  @override
  Widget build(BuildContext context) {
    ChatProvider chatData = Provider.of<ChatProvider>(context);
    UserProvider user = Provider.of<UserProvider>(context);
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final selectColor = Colors.indigoAccent;
    void onTaps() {
      if (chatData.isSelectionMode) {
        Provider.of<ChatProvider>(context, listen: false)
            .setSelectedFlag(isSelected, index);
        Provider.of<ChatProvider>(context, listen: false).setSelectionMode();
        if (isSelected) {
          print('ah ah');
          Provider.of<ChatProvider>(context, listen: false)
              .removeMessage(index);
        } else {
          print('hurray');
          Provider.of<ChatProvider>(context, listen: false)
              .setMessage(index, message);
        }
        chatData.messages.forEach((key, value) {
          var as = value.messageContent;
          print('gasg $as');
        });
      }
    }

    void onLongPressed() {
      Provider.of<ChatProvider>(context, listen: false)
          .setSelectedFlag(isSelected, index);
      Provider.of<ChatProvider>(context, listen: false).setSelectionMode();
      if (isSelected) {
        print('ah ah');
        Provider.of<ChatProvider>(context, listen: false).removeMessage(index);
      } else {
        print('hurray');
        Provider.of<ChatProvider>(context, listen: false)
            .setMessage(index, message);
      }
    }

    return GestureDetector(
      onTap: onTaps,
      onLongPress: onLongPressed,
      child: Container(
        color: isSelected ? selectColor.withOpacity(0.2) : null,
        padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
        child: Align(
          alignment: (!isMe ? Alignment.topLeft : Alignment.topRight),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            color: Color.fromRGBO(235, 235, 235, 1),
            /*color: isSelected
                ? selectColor.withOpacity(0.1)
                : Color.fromRGBO(235, 235, 235, 1),*/
            elevation: 8,
            child: Container(
              width: !isMe
                  ? MediaQuery.of(context).size.width * 0.8
                  : MediaQuery.of(context).size.width * 0.7,
              /*decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                //color: Color.fromRGBO(235, 235, 235, 1),
                color: isSelected
                    ? selectColor.withOpacity(0.1)
                    : Color.fromRGBO(235, 235, 235, 1),
              ),*/
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        !isMe ? 'Doctor' : time,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.699999988079071),
                            fontFamily: 'Inter',
                            fontSize: !isMe ? 14 : 12,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight:
                                isMe ? FontWeight.normal : FontWeight.w700,
                            height: 1.1428571428571428),
                      ),
                      Text(
                        !isMe ? '15:20' : 'You', //TODO USE REAL DOCTORS NAME
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontFamily: 'Inter',
                            fontSize: !isMe ? 12 : 14,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight:
                                !isMe ? FontWeight.normal : FontWeight.w700,
                            height: 1),
                      )
                    ],
                  ),
                  SizedBox(height: 6),
                  Align(
                    alignment:
                        !isMe ? Alignment.centerLeft : Alignment.centerRight,
                    child: Text(
                      message.messageContent,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Inter',
                          fontSize: 14,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.w400,
                          height: 1.1428571428571428),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

/*Widget buildMessage() => Column(
    crossAxisAlignment:
    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        message.message,
        style: TextStyle(color: isMe ? Colors.black : Colors.white),
        textAlign: isMe ? TextAlign.end : TextAlign.start,
      ),
    ],
  );*/
}
