import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:secur_chat/modules/home/home_controller.dart';
import 'package:get/get.dart';


class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.find();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: BuildDrawer(context),
      appBar:  AppBar(
        title:Text('Chat YaA',style: TextStyle(fontSize: 25),),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap:(){
                if(!homeController.UsersListIsLoad.value)
                  GetAllUser();
                scaffoldKey.currentState!.openEndDrawer();
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/icons/add_chat.png',
                    ),
                    fit: BoxFit.contain
                  )
                ),
              ),
            ),
          )
        ],
      ),
      body: Obx((){
        if(!homeController.ChatsListIsLoad.value){
          return Center(
            child: LoadingAnimationWidget.prograssiveDots(
              size: 30, color: Color(0xffB73E3E),
            ),
          );
        }else{
          if(homeController.ChatsList.length == 0){
            return Center(
              child: Text('No chats',style: TextStyle(fontSize: 30, color: Color(0xffB73E3E),),)
            );
          }else{
            return ListView.builder(
              itemCount: homeController.ChatsList.length,
              itemBuilder: (context,index){
                return BuildUserCard(context,homeController.ChatsList[index].name,homeController.ChatsList[index].phone,

                    homeController.ChatsList[index].user2 == homeController.IdUser ? homeController.ChatsList[index].user1 : homeController.ChatsList[index].user2);
              },
            );
          }
        }
      }),

    );
  }


  Drawer BuildDrawer(BuildContext context){
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height *.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight:Radius.circular(5) ),
                gradient: LinearGradient(
                    colors: [
                      Color(0xffB73E3E),
                      Color(0xffDD5353),
                      Color(0xffe78383)
                    ]
                )
            ),
            child:
            Center(
              child: Column(
                children: [
                  SizedBox(height:MediaQuery.of(context).size.height *.05 ,),
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xffB73E3E),blurRadius: 7,offset: Offset(12,12)
                            )
                          ],
                          image: DecorationImage(
                              image: AssetImage('assets/icons/chat_icon.png'),
                              fit: BoxFit.contain
                          )
                      ),
                      child: null
                  ),
                  SizedBox(height: 10,),
                  Text('Chat YaA',style: TextStyle(fontSize: 30,color: Colors.white),),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx((){
              if(!homeController.UsersListIsLoad.value){
                return Center(
                  child: LoadingAnimationWidget.prograssiveDots(
                    size: 30, color: Color(0xffB73E3E),
                  ),
                );
              }else{
                if(homeController.UsersList.length == 0){
                  return Center(
                    child: Text('No users',style: TextStyle(fontSize: 30, color: Color(0xffB73E3E),),),
                  );
                }else{
                  return ListView.builder(
                    itemCount: homeController.UsersList.length,
                    itemBuilder: (context,index){
                      return BuildUserCard(context,homeController.UsersList[index].name,homeController.UsersList[index].phone,homeController.UsersList[index].id);
                    },
                  );
                }
              }
            }),
          )
        ],
      ),
    );
  }

  Widget BuildUserCard(BuildContext context , String Name , int Phone  , int ResId){
    return GestureDetector(
      onTap: (){
        Get.toNamed('/messages_chat',arguments: {'res_name':Name , 'res_phone':Phone},parameters: {'res_id':ResId.toString()});
      },
      child: Container(
        child: Padding(
          padding:  EdgeInsets.only(top: 4,bottom: 4),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  image:
                  DecorationImage(
                    image:AssetImage('assets/icons/user_profile.png'),
                    onError: (err,dd){
                      print(err);
                    },
                    fit: BoxFit.cover,
                  )),
            ),
            title: Text(
              '${Name}',
              style: TextStyle(fontSize: 18, color: Color(0xffDD5353),),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${Phone}',
              style: TextStyle(fontSize: 13, color: Colors.black,),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  void GetAllUser()async{
    await homeController.GetUsers();
  }
}
