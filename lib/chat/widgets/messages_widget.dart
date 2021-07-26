import 'package:e_care_mobile/chat/api/chat_api.dart';
import 'package:e_care_mobile/chat/models/chatMessageModel.dart';
import 'package:e_care_mobile/providers/chat_provider.dart';
import 'package:e_care_mobile/providers/user_provider.dart';
import 'package:e_care_mobile/userData/user.dart';
import 'package:e_care_mobile/util/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:item_selector/item_selector.dart';
import 'package:provider/provider.dart';

import 'message_widget.dart';

class MessagesWidget extends StatefulWidget {
  final String idUser;
  final Function(bool) messageSelected;
  final Function(int) onCountChanged;

  MessagesWidget({
    @required this.idUser,
    @required this.messageSelected,
    @required this.onCountChanged,
    Key key,
  }) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<MessagesWidget> {
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};

  @override
  void initState() {
    super.initState();
    //widget.changeAppBar();
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserProvider>(context).user;
    ChatProvider chatData = Provider.of<ChatProvider>(context);
    String userId = userData.patientId;
    return StreamBuilder<List<ChatMessage>>(
      stream:
          FirebaseApi.getMessages(userData.patientId, widget.idUser), //idUser),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: loadingSpinner(48.0, 2.0));
          default:
            if (snapshot.hasError) {
              return buildText('Something Went Wrong Try later');
            } else {
              final messages = snapshot.data;
              messages.removeWhere((element) => element.deleted == userId);
              return messages.isEmpty
                  ? buildText('Say Hi..')
                  : ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      //physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        //messages.removeWhere((element) => element.deleted['everyone'] == true);
                        final message = messages[index];
                        String formattedTime =
                            DateFormat.Hm().format(message.createdAt);

                        selectedFlag[index] = selectedFlag[index] ?? false;
                        List count = [];
                        chatData.selectedFlag[index] =
                            chatData.selectedFlag[index] ?? false;
                        //var axx =  chatData.selectedFlag;
                        bool isSelected = chatData.selectedFlag[index];
                        //print(chatData.selectedFlag);
                        return MessageWidget(
                            index: index,
                            message: message,
                            isMe: message.userId == userData.patientId,
                            time: formattedTime,
                            onLongPress: () =>
                                onLongPress(isSelected, index, count),
                            onTap: () => onTap(isSelected, index, count),
                            isSelected: isSelected);
                      },
                    );
            }
        }
      },
    );
  }

  void onTap(bool isSelected, int index, count) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
      selectedFlag.forEach((key, value) {
        if (value == true) {
          count.add(value);
        }
      });
      widget.onCountChanged(count.length);
      widget.messageSelected(isSelectionMode);
      /*FirebaseApi.getMessageId(
          userData.user.patientId,
          widget.receiverId,
          'messageId');*/ // TODO
    } else {
      // Open Detail Page
    }
  }

  void onLongPress(bool isSelected, int index, count) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
    selectedFlag.forEach((key, value) {
      if (value == true) {
        count.add(value);
      }
    });
    widget.onCountChanged(count.length);
    widget.messageSelected(isSelectionMode);
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
