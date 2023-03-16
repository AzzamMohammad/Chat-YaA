import 'package:secur_chat/models/messages.dart';
import 'package:http/http.dart' as http;

import '../../config/server_config.dart';

class MessagesChatServer{
  bool IsLoadMessages = false;

  int ChatId = 0;

  bool AbilityToSendGetMessagesApi = true;
  var GetAllMessagesRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetAllMessagesURL);
  Future<List<Message>> GetChatsList(String Token , int UserId)async{
    try{
      AbilityToSendGetMessagesApi = false;
      var jsonResponse = await http.post(GetAllMessagesRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
        body: {
        'user_id' : '${UserId}'
        }
      );
      if(jsonResponse.statusCode == 200){
        Messages response = messagesFromJson(jsonResponse.body);
        IsLoadMessages = true;
        if(response.status == true){
          ChatId = response.ChatId;
          AbilityToSendGetMessagesApi = true;
          return response.data;
        }else{
          AbilityToSendGetMessagesApi = true;
          return [];
        }
      }else{
        AbilityToSendGetMessagesApi = true;
        return [];
      }
    }catch(e){
      AbilityToSendGetMessagesApi = true;
      print(e);
      return [];
    }
  }


}