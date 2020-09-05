import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


User u;
class ChatScreen extends StatefulWidget {
  static String id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message;
  final messageTextController = TextEditingController();
  final _firestone=FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;
  void getCurrentUser() async {
    try{final user= _auth.currentUser;
    if(user!=null){
        u=user;
        print(u);
    }}
    catch(e){
      print(e);
    }

  }
  void getMessages() async {
    final messages = await _firestone.collection('messages').get();
    for (var m in messages.docs){
      print(m.data());
    }
  }
  void messageStream() async{
    await for(var snap in _firestone.collection('messages').snapshots()){
      for (var message in snap.docs){
        print(message.data);
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getMessages();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {

                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(firestone: _firestone),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {

                      if(message.length>0){
                        _firestone.collection('messages').add({'text':message,'sender':u.email,});
                        messageTextController.clear();
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key key,
    @required FirebaseFirestore firestone,
  }) : _firestone = firestone, super(key: key);

  final FirebaseFirestore _firestone;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:_firestone.collection('messages').snapshots(),
      // ignore: missing_return
      builder: (context,snap) {
        if(snap.hasData){
          final messages=snap.data.docs.reversed;
          List<MessageBubble> messageW=[];
          for (var mText in messages){
            final messageText=mText.data()['text'];
            final messageSender=mText.data()['sender'];
            final currentUser=u.email;

            if(currentUser==messageSender){

            }
            final messageBubble = MessageBubble(text:messageText ,sender: messageSender,isMe: currentUser==messageSender,);
            messageW.add(messageBubble);
          }
          return Expanded(

            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              children: messageW,
            ),
          );
        }
        else if(!snap.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender,this.text,this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  // ignore: non_constant_identifier_names
  Color color_sender(){
    if(isMe){
      return Colors.lightBlueAccent;
    }
    else{
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
          ),
          Material(
            borderRadius: BorderRadius.only(topLeft: isMe ? Radius.circular(30):Radius.circular(0),topRight: isMe ? Radius.circular(0):Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
            elevation: 10,
            color: color_sender(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                  '$text',
                style: TextStyle(
                  color: isMe ? Colors.white: Colors.black54,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
