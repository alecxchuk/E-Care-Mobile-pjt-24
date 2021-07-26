import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageDelete {
  final VoidCallback deleteMessageById;
  final VoidCallback deleteMessageForEveryone;

  const MessageDelete({
    @required this.deleteMessageById,
    @required this.deleteMessageForEveryone,
  });

  //Error Dialogs
  Future<bool> messageDialog(BuildContext context) {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text('Delete Message?'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                /*Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Center(
                        child: Text(e is String ? e : e.message.toString()))),*/
                Visibility(
                  visible: true,
                  child: Container(
                      height: 50.0,
                      child: Row(children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              deleteConfirmation(context, 'everyone');
                            },
                            child: Text('Delete for Everyone'))
                      ])),
                ),
                Container(
                    height: 50.0,
                    child: Row(children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'))
                    ])),
                Container(
                    height: 50.0,
                    child: Row(children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            deleteConfirmation(context, 'me');
                          },
                          child: Text('Delete for me'))
                    ]))
              ]));
        });
  }

  Future<bool> deleteConfirmation(BuildContext context, text) {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text(
                'Are you sure you want to delete?',
                style: TextStyle(fontSize: 15),
              ),
              content: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    height: 50.0,
                    child: Row(children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            messageDialog(context);
                          },
                          child: Text('No'))
                    ])),
                Container(
                    height: 50.0,
                    child: Row(children: [
                      TextButton(
                          onPressed: () {
                            text == 'me'
                                ? deleteMessageById()
                                : deleteMessageForEveryone();
                            Navigator.of(context).pop();
                          },
                          child: Text('Yes'))
                    ]))
              ]));
        });
  }
}
