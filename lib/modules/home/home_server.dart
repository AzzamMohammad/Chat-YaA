
import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../models/chats.dart';
import '../../models/users.dart';


class HomeServer{

  bool IsLoadUsers = false ;
  bool IsLoadChats = false;


  bool AbilityToSendGetUserApi = true;
  bool AbilityToSendGetChatsApi = true;
  var GetUsersRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetUsersURL);
  var GetChatsRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetChatsURL);

  Future<List<User>> GetUsersList(String Token)async{
    try{
      AbilityToSendGetUserApi = false;
      var jsonResponse = await http.get(GetUsersRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          }
      );
      if(jsonResponse.statusCode == 200){

        Users response = usersFromJson(jsonResponse.body);

        IsLoadUsers = true;
        if(response.status == true){
          AbilityToSendGetUserApi = true;
          return response.data;
        }else{
          AbilityToSendGetUserApi = true;
          return [];
        }

      }else{
        AbilityToSendGetUserApi = true;
        return [];
      }
    }catch(e){
      AbilityToSendGetUserApi = true;
      print(e);
      return [];
    }
  }


  Future<List<chat>> GetChatsList(String Token)async{
    try{
      AbilityToSendGetChatsApi = false;
      var jsonResponse = await http.get(GetChatsRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          }
      );
      if(jsonResponse.statusCode == 200){

        Chats response = chatsFromJson(jsonResponse.body);

        IsLoadChats = true;
        if(response.status == true){
          AbilityToSendGetChatsApi = true;
          return response.data;
        }else{
    AbilityToSendGetChatsApi = true;
          return [];
        }

      }else{
    AbilityToSendGetChatsApi = true;
        return [];
      }
    }catch(e){
    AbilityToSendGetChatsApi = true;
      print(e);
      return [];
    }
  }


}