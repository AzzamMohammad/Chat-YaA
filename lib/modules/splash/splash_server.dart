import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart' as sym;
import '../../config/server_config.dart';
import '../../constant.dart';
import '../../storage/shared_data.dart';
import 'package:http/http.dart' as http;
import 'package:crypton/crypton.dart';

class SplashServer{
  var loginRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.LoginURL);
  var GetPublicServerKayRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetPublicServerKayURL);
  var SendSessionKayRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SendSessionKayURL);
  var SendPublicKayDigitalSignatureRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SendPublicKayDigitalSignatureURL);

  String message = '';

  Future<bool> SendLoginRequest(String PhoneNumber ,String Password  , SharedData sharedData)async{
    try{
      var jsonResponse = await http.post(loginRoute,
          headers: {
            'Accept':'application/json',
          },
          body: {
            'phone' : '${PhoneNumber}',
            'password' : '${Password}',
          }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status'] == true){
          message = response['msg'];
           sharedData.SaveToken(response['Data']['token']);
           sharedData.SaveId(response['Data']['id']);
           sharedData.SaveSecretKay(int.parse(PhoneNumber));
          return true;
        }
        else{
          message = response['msg'];
          return false;
        }
      }else{
        message =  'Connection error';
        return false;
      }

    }catch(e){
      message =  'Connection error';
      print(e);
      return false;
    }
  }


  /** ****************************************************************** */
  /** ------------------------------- PGP ------------------------------ */
  /** ****************************************************************** */


  /** Handling parameters for PGP */
  Future<bool> HandlingParametersForPGP(String Token)async{
    String ServerPublicKay = await GetPublicServerKay(Token);
    if(ServerPublicKay == '')
      return false;
    String MyPrivateKay = GenerateRandomPrivateKAy();
    String SessionKay = GenerateSessionKay(ServerPublicKay,MyPrivateKay);
    bool State = await SendSessionKayToServer(Token,SessionKay);
    if(State){
      SharedData sharedData = SharedData();
      await sharedData.SavePGPPrivateKay(MyPrivateKay);
      return true;
    }
    return false;
  }



  /** Generate random private kay */
  String GenerateRandomPrivateKAy(){
    String RandStr1 = GetRandomString(8);
    String RandStr2 = GetRandomString(8);
    return RandStr1 + RandStr2;
  }
  String GetRandomString(int StringLength) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String RandStr = String.fromCharCodes(
      Iterable.generate(
        StringLength,
            (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
    return RandStr;
  }


  /** Generate random session kay */
  String GenerateSessionKay(String ServerPublicKay , String MyPrivateKay){
    final publicKey = RSAKeyParser().parse(ServerPublicKay) as sym.RSAPublicKey;
    final plainText = MyPrivateKay;
    final encrypter = Encrypter(RSA(publicKey: publicKey));
    final encrypted = encrypter.encrypt(plainText);
    return encrypted.base16;
  }

  /** Send random session kay */
  Future<bool> SendSessionKayToServer(String Token , String SessionKay)async{
    final fullString = SessionKay;
    var number;
    for (int i = 0; i <= fullString.length - 8; i += 8) {
      final hex = fullString.substring(i, i + 8);
      number = int.parse(hex, radix: 16);
    }
    try{
      var jsonResponse = await http.post(SendSessionKayRoute,
          headers: {
            'Accept':'application/json',
            'auth_token' : '${Token}'
          },
        body: {
        'key':'${SessionKay}'
        }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        message = response['msg'];
        if(response['status'] == true){
          return true;
        }
        else{
          message = response['msg'];
          return false;
        }
      }else{
        message =  'Connection error ';
        return false;
      }

    }catch(e){
      message =  'Connection error ';
      print(e);
      return false;
    }
  }

/** ################################################################## */







/** ****************************************************************** */
/** ------------------------- Digital Signature ---------------------- */
/** ****************************************************************** */

  /** Handling parameters for Digital Signature */
  Future<bool> HandlingParametersForDigitalSignature(String Token)async{
    ServerPublicKay = await GetPublicServerKay(Token);
    if(ServerPublicKay == '')
      return false;
    GenerateAndStorePublicAndPrivateKar();
    bool State = await SendPublicKayToServer(Token,publicKey!.toFormattedPEM());
    if(!State){
      return false;
    }
    return true;
  }

  /** Generate and store public and private kay */

  void GenerateAndStorePublicAndPrivateKar()async{
    RSAKeypair rsaKeypair = RSAKeypair.fromRandom();
     privateKey = rsaKeypair.privateKey;
     publicKey = rsaKeypair.publicKey;
  }

  /** Send public kay */
  Future<bool> SendPublicKayToServer(String Token , String PublicKay)async{
    try{
      var jsonResponse = await http.post(SendPublicKayDigitalSignatureRoute,
          headers: {
            'Accept':'application/json',
            'auth_token' : '${Token}'
          },
          body: {
            'key':'${PublicKay}'
          }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        message = response['msg'];
        if(response['status'] == true){
          return true;
        }
        else{
          message = response['msg'];
          return false;
        }
      }else{
        message =  'Connection error ';
        return false;
      }

    }catch(e){
      message =  'Connection error ';
      print(e);
      return false;
    }
  }

  /** ################################################################## */


  /** Get public server kay */
  Future<String>GetPublicServerKay(String Token)async{
    try{
      var jsonResponse = await http.get(GetPublicServerKayRoute,
          headers: {
            'Accept':'application/json',
            'auth_token' : '${Token}'
          }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        message = response['msg'];
        if(response['status'] == true){
          return response['Date'];
        }
        else{
          message = response['msg'];
          return '';
        }
      }else{
        message =  'Can not get public server kay ';
        return '';
      }

    }catch(e){
      message =  'Can not get public server kay ';
      print(e);
      return '';
    }
  }

}