import 'dart:math' as math; // import this

import 'package:e_care_mobile/chat/start_chat.dart';
import 'package:e_care_mobile/chat/user_contacts.dart';
import 'package:e_care_mobile/chat/widgets/messages_widget.dart';
import 'package:e_care_mobile/chat/widgets/new_message.dart';
import 'package:e_care_mobile/providers/chat_provider.dart';
import 'package:e_care_mobile/providers/user_provider.dart';
import 'package:e_care_mobile/screens/profile/doctors_profile.dart';
import 'package:e_care_mobile/util/delete_message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'api/chat_api.dart';
import 'models/chatMessageModel.dart';

class ChatDetailPage extends StatefulWidget {
  final String receiverId;
  final String doctorName;
  final String doctorSurname;

  ChatDetailPage(
      {@required this.receiverId,
      @required this.doctorName,
      this.doctorSurname});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  String dropdownValue;
  String firstname;
  String surname;
  bool showSelected = false;
  int selectNumber = 0;

  @override
  void deactivate() {
    Provider.of<ChatProvider>(context, listen: false).clearMessage();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userData = Provider.of<UserProvider>(context);
    ChatProvider chatData = Provider.of<ChatProvider>(context);
    bool selectionMode = chatData.isSelectionMode;
    Provider.of<ChatProvider>(context, listen: false)
        .setReceiverId(widget.receiverId);
    String selectCount = chatData.count.toString();

    String userId = userData.user.patientId;
    String receiverId = widget.receiverId;

    var deleteMessageById = () async {
      chatData.deleteMessageByMessageId(userId, receiverId);
    };
    var deleteMessageForEveryone = () async {
      chatData.deleteMessageForEveryone(userId, receiverId);
    };
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(75, 165, 77, 1),
        flexibleSpace: SafeArea(
          child: Container(
            //color:Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  iconSize: 24,
                  onPressed: () {
                    if (chatData.isSelectionMode) {
                      Provider.of<ChatProvider>(context, listen: false)
                          .clearMessage();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                Visibility(
                  visible: !selectionMode, // TODO
                  child: Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://randomuser.me/api/portraits/men/5.jpg"),
                          maxRadius: 20,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Container(
                            width: 180,
                            child: InkWell(
                              highlightColor: Colors.indigoAccent,
                              splashColor: Colors.grey,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DoctorsProfile()));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 180,
                                    child: Text(
                                      widget.doctorName != null
                                          ? "Dr. " + firstname
                                          : 'Dr. Peter',
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Online",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: selectionMode, //TODO
                  child: Expanded(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(selectCount,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24)),
                          SizedBox(width: 10),
                          IconButton(
                            iconSize: chatData.count > 1 ? 0 : 24,
                            onPressed: () {
                              //Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.reply,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            iconSize: 24,
                            onPressed: () {
                              print('delete me');
                              //deleteMessageById();
                              MessageDelete(
                                      deleteMessageById: deleteMessageById,
                                      deleteMessageForEveryone:
                                          deleteMessageForEveryone)
                                  .messageDialog(context);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserContacts()));
                            },
                            icon: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Icon(
                                Icons.reply,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ]),
                  ),
                ),
                Container(
                  child: PopupMenuButton<String>(
                    icon: SvgPicture.asset('assets/images/more_horiz_icon.svg',
                        width: 24, semanticsLabel: 'vector'),
                    elevation: 16,
                    onSelected: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                      switch (newValue) {
                        case 'closeChat':
                          Navigator.pop(context);
                          break;
                        case 'clearChat':
                          FirebaseApi.clearChat(
                              userData.user.patientId, widget.receiverId);
                          break;
                        case 'changeDoctor':
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StartChat()));
                          break;
                        default:
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'closeChat',
                        child: Text('Close Chat'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'clearChat',
                        child: Text('Clear Chat'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'changeDoctor',
                        child: Text('Change Doctor'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
                child: MessagesWidget(
                  idUser: widget.receiverId,
              //changeAppBar: (showSelected, selectNumber) => onLongPress(showSelected, selectNumber),
              messageSelected: (selected) {
                setState(() {
                  showSelected = selected;
                });
              },
              onCountChanged: (int val) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  setState(() => selectNumber = val);
                  print('ppp $selectNumber');
                });
              },
            )),
            NewMessageWidget(
                userId: userData.user.patientId,
                receiverId: widget.receiverId,
                doctorName: widget.doctorName),
          ],
        ),
      ),
    );
  }

  void onLongPress(bool isSelected, int number) {
    setState(() {
      showSelected = isSelected;
      selectNumber = number;
    });
  }

  @override
  void initState() {
    super.initState();
    List<String> arr = widget.doctorName.split(' ');
    String first = arr[0];
    String last = arr[1];
    setState(() {
      firstname = first;
      surname = last;
    });
  }
}
