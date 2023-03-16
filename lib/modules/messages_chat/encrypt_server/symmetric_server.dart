import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../../../config/server_config.dart';

class SymmetricServer{
  String Message = '';
  var SendMessageSymmetricRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SendMessageSymmetricURL);

  /** ///////////////////////////////////////////// */
  /** Handling and send Encrypt Message */

  // Handling the Message to send
  Future<bool> EncryptSymmetricMessage(String Token , int ChatId , String Message , String SecretKay)async{
    String EncryptedMessage = GetEncryptedMessage(Message,SecretKay);
    String MAC = GetMackFromHash(Message);
    return SendNewMessage(Token,ChatId,EncryptedMessage,MAC);
  }

  // Get Encrypt Message
  String GetEncryptedMessage(String Message , String SecretKay){
    final plainText = Message;
    final key =Key.fromUtf8(SecretKay);
    final iv = IV.fromUtf8('1234567891234567');
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  // Send the message to server
  Future<bool> SendNewMessage(String Token , int ChatId , String EncryptMessage , String MAC)async{
    try{
      var jsonResponse = await http.post(
        SendMessageSymmetricRoute,
        headers: {
          'auth-token' : '${Token}',
          'Accept': 'application/json',
        },
        body: {
          'chat_id':'${ChatId}',
          'message':'${EncryptMessage}',
          'MAC':'${MAC}',
        },
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        Message = response['msg'];
        if(response['status'] == true){
          print(response['data']);
          print(response['msg']);
          print(EncryptMessage);
          print(MAC);
          return true;
        }

        else
          return false;
      }else{
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
  String DecodeSymmetricMessage(String EncryptedMessage , String MAC , String SecretKay){
    String Message = GetMessage(EncryptedMessage,SecretKay);
    String CorrectMac = GetMackFromHash(Message);
    if(CorrectMac.compareTo(MAC) == 0)
      return Message;
    else
      return '';
    
  }
  // Decode Encrypt Message
  String GetMessage(String EncryptedMessage , String SecretKay){
    final key =Key.fromUtf8(SecretKay);
    final iv = IV.fromUtf8('1234567891234567');
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final Decrypted = encrypter.decrypt64(EncryptedMessage, iv: iv);
    return Decrypted;
  }
  /** ///////////////////////////////////////////// */

  // Get MAC
  String GetMackFromHash(String Message){
    var bytes = utf8.encode(Message);
    return md5.convert(bytes).toString();
  }

}