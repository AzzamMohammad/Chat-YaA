import 'package:flutter/material.dart';
import 'package:secur_chat/modules/messages_chat/messages_chat_controller.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MessagesChatScreen extends StatelessWidget {
  final MessagesChatController messagesChatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  image: DecorationImage(
                    image: AssetImage('assets/icons/user_profile.png'),
                    onError: (err, dd) {
                      print(err);
                    },
                    fit: BoxFit.cover,
                  )),
            ),
            title: Text(
              '${messagesChatController.ResName}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${messagesChatController.ResPhone}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        body: ScaffoldBody(context));
  }

  Widget ScaffoldBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (!messagesChatController.MessagesListIsLoad.value) {
              return Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  size: 30,
                  color: Color(0xffB73E3E),
                ),
              );
            } else {
              if (messagesChatController.NumberOfMessageInChat.value == 0) {
                return Center(
                    child: Text(
                  'No messages',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xffB73E3E),
                  ),
                ));
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: messagesChatController.NumberOfMessageInChat.value,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return ReturnMessageByType(context, index);
                  },
                );
              }
            }
          }),
        ),
        Container(
          padding: EdgeInsets.all(8),
          // height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .8,
                child: TextFormField(
                  controller: messagesChatController.SendFieldController,
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'Your message',
                  ),
                  onChanged: (value){
                    messagesChatController.MessageContent = value;
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  SendMessage(context);
                },
                child: Icon(
                  Icons.send,
                  size: 25,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget ReturnMessageByType(BuildContext context, int index) {
    if (messagesChatController.MessagesList[index].senderId ==
        messagesChatController.ResId)
      return Obx(() {
        return BuildReceivingMessageCardForReceiver(
            context, messagesChatController.MessagesList[index].message,
            messagesChatController.MessagesList[index].SendingLevel.value);
      }
      );
    else
      return Obx((){
        return  BuildReceivingMessageCardForSender(
            context, messagesChatController.MessagesList[index].message, messagesChatController.MessagesList[index].SendingLevel.value);
      });

    }

  Widget BuildReceivingMessageCardForReceiver(
      BuildContext context, String Message, String? SendingType,) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .4, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: SendingType == 'arrived'? Colors.blue.shade300:Colors.blue.shade50),
                  child: Text(
                    Message,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget BuildReceivingMessageCardForSender(
    BuildContext context,
    String Message,
      String? SendingType,

  ) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
          padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * .4, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: SendingType == 'arrived'? Colors.red.shade300:Colors.red.shade50),
                  child: Text(
                    Message,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          )),
    );
  }



  void SendMessage(BuildContext context) async {
    if(messagesChatController.MessageContent == '')
      return ;

    await messagesChatController.SendMessage();
  }
}
