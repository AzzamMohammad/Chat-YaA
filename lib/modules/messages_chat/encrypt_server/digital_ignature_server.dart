import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import '../../../config/server_config.dart';
import '../../../constant.dart';
import 'package:pointycastle/asymmetric/api.dart' as sym;





class DigitalSignatureServer{
  String Message = '';
  var SendMessageDigitalSignatureRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SendMessageDigitalSignatureURL);

  /** ///////////////////////////////////////////// */
  /** Handling and send Encrypt Message */

  // Handling the Message to send
  Future<bool> EncryptDigitalSignatureMessage(String Token , int ChatId , String Message)async{
    String ServerKay = ServerPublicKay!;
    String EncryptedMessage = GetEncryptedMessage(Message,ServerKay);
    // final List<int> codeUnits = Message.codeUnits;
    // final Uint8List unit8List = Uint8List.fromList(codeUnits);
    var  signature = privateKey!.createSHA256Signature(utf8.encode(Message) as Uint8List);
    return SendNewMessage(Token,ChatId,EncryptedMessage,signature);
  }


  // Get Encrypt Message
  String GetEncryptedMessage(String Message , String ServerKay){
    final publicKey = RSAKeyParser().parse(ServerKay) as sym.RSAPublicKey;
    final plainText = Message;
    final encrypter = Encrypter(RSA(publicKey: publicKey));
    final encrypted = encrypter.encrypt(plainText);
    return encrypted.base16;
  }


  // Send the message to server
  Future<bool> SendNewMessage(String Token , int ChatId , String EncryptMessage , var Signature)async{
    var hhh = hex.encode(Signature);
    print(hhh);
    try{
      var jsonResponse = await http.post(
        SendMessageDigitalSignatureRoute,
        headers: {
          'auth-token' : '${Token}',
          'Accept': 'application/json',
        },
        body: {
          'chat_id':'${ChatId}',
          'message':'${EncryptMessage}',
          'signature':'${hhh}',
        },
      );
    print(ChatId);
    if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        Message = response['msg'];
        if(response['status'] == true){
          // print(response['data']);
          print(response['msg']);
          // print(EncryptMessage);
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
  String DecodeDigitalSignatureMessage(String EncryptedMessage , String signature){
    String Message = GetMessage(EncryptedMessage);
    print('The message is :${Message}');
    bool IsCorrectSignature = CheckSignature(Message,signature);
    if(IsCorrectSignature)
      return Message;
    else
      return '';

  }
  // Decode Encrypt Message
  String GetMessage(String EncryptedMessage){
    final List<int> codeUnits = EncryptedMessage.codeUnits;
    final Uint8List Encterp = Uint8List.fromList(codeUnits);
    Encrypted d = Encrypted(Encterp);
    final private = RSAKeyParser().parse(privateKey!.toPEM()) as sym.RSAPrivateKey;
    final encrypter = Encrypter(RSA(privateKey: private));
    final encrypted = encrypter.decrypt(d);
    print(encrypted);
    return encrypted;
  }
  
  
  bool CheckSignature(String Message, String signature){
    String ServerKay = ServerPublicKay!;
    final publicKey = RSAKeyParser().parse(ServerKay) as sym.RSAPublicKey;
    final signer = Signer(RSASigner(RSASignDigest.SHA256, publicKey: publicKey));
    bool check = signer.verify64(Message,signature);
    return check;
  }
  /** ///////////////////////////////////////////// */


}