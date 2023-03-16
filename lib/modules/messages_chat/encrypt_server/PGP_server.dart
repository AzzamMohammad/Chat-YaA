import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import '../../../config/server_config.dart';

class PGPServer{
  String Message = '';
  var SendPGPMessageRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SendPGPMessageURL);

  /** ///////////////////////////////////////////// */
  /** Handling and send Encrypt Message */

  // Handling the Message to send
  Future<bool> EncryptPGPMessage(String Token , int ChatId , String Message,String PGPPrivateKay)async{
    String EncryptedMessage = GetEncryptedMessage(Message,PGPPrivateKay);
    print(EncryptedMessage);
    print('slssssssss');
    return SendNewMessage(Token,ChatId,EncryptedMessage);
  }

  // Get Encrypt Message
  String GetEncryptedMessage(String Message , String SecretKay){
    print(SecretKay);
    final plainText = Message;
    final key =Key.fromUtf8(SecretKay);
    final iv = IV.fromUtf8('1234567891234567');
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  // Send the message to server
  Future<bool> SendNewMessage(String Token , int ChatId , String EncryptMessage)async{
    try{
      print(EncryptMessage);
      var jsonResponse = await http.post(
        SendPGPMessageRoute,
        headers: {
          'auth-token' : '${Token}',
          'Accept': 'application/json',
        },
        body: {
          'chat_id':'${ChatId}',
          'message':'${EncryptMessage}',
        },
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        Message = response['msg'];
        if(response['status'] == true){
          return true;
        }
        else{
          print(Message);
        return false;
        }

      }else{
        print(jsonResponse.statusCode);
        print(jsonResponse.body);
      return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }



  /** ///////////////////////////////////////////// */
  /** Decrypt the received message */

  // Handling the received Message
  String DecodePGPMessage(String EncryptedMessage , String PGPPrivateKay){
    String Message = GetMessage(EncryptedMessage,PGPPrivateKay);
    return Message;
  }
  // Decode Encrypt Message
  String GetMessage(String EncryptedMessage ,  String PGPPrivateKay){
    final key =Key.fromUtf8(PGPPrivateKay);
    final iv = IV.fromUtf8('1234567891234567');
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final Decrypted = encrypter.decrypt64(EncryptedMessage, iv: iv);
    return Decrypted;
  }


}