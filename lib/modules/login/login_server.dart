import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart' as sym;
import '../../constant.dart';
import 'package:crypton/crypton.dart';

import '../../config/server_config.dart';
import '../../models/person.dart';
import '../../storage/shared_data.dart';

class LoginServer {
  var loginRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.LoginURL);
  var GetPublicServerKayRoute =
      Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetPublicServerKayURL);
  var SendSessionKayRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SendSessionKayURL);
  var SendPublicKayDigitalSignatureRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SendPublicKayDigitalSignatureURL);

  String message = '';

  Future<bool> SendLoginRequest(Person person, SharedData sharedData) async {
    try {
      var jsonResponse = await http.post(loginRoute, headers: {
        'Accept': 'application/json',
      }, body: {
        'phone': '${person.PhoneNumber}',
        'password': '${person.Password}',
      });
      if (jsonResponse.statusCode == 200) {
        var response = jsonDecode(jsonResponse.body);
        if (response['status'] == true) {
          message = response['msg'];
           sharedData.SaveToken(response['Data']['token']);
           sharedData.SaveId(response['Data']['id']);
           sharedData.SaveSecretKay(int.parse(person.PhoneNumber));
          return true;
        } else {
          message = response['msg'];
          return false;
        }
      } else {
        message = 'Connection error';
        return false;
      }
    } catch (e) {
      message = 'Connection error';
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
    print(ServerPublicKay);
    print('fffffffffffffffffaaaaaaaaaaaaaaaaaaaaaaaakkkkkkkkkkkkkkkk');
    if(ServerPublicKay == '')
      return false;
    // String MyPrivateKay = GenerateRandomPrivateKAy();
    String MyPrivateKay = 'as23ddf7fnd8ii8h';
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














  // Future<bool> HandlingParametersForPGP(String Token)async{
  //   String ServerPublicKay = await GetPublicServerKay(Token);
  //   if(ServerPublicKay == '')
  //     return false;
  //   String MyPrivateKay = GenerateRandomPrivateKAy();
  //   String SessionKay = GetSessionKay(ServerPublicKay,MyPrivateKay);
  //   bool State = await SendSessionKayToServer(Token,SessionKay);
  //   print('ffffffffffffffffffffffffff');
  //
  //   if(State){
  //     SharedData sharedData = SharedData();
  //     await sharedData.SavePGPPrivateKay(MyPrivateKay);
  //     return true;
  //   }
  //   return false;
  // }
  //
  // String GenerateRandomPrivateKAy(){
  //   String RandStr1 = GetRandomString(8);
  //   String RandStr2 = GetRandomString(8);
  //   return RandStr1 + RandStr2;
  // }
  //
  // String GetSessionKay(String ServerPublicKay , String MyPrivateKay){
  //   // String publicPem = await rootBundle.loadString('${AppStorage}/public.pem');
  //   // final publicKey1 = RSAKeyParser().parse(ServerPublicKay) as RSAPublicKey;
  //   final publicKey = RSAKeyParser().parse(ServerPublicKay) as sym.RSAPublicKey;
  //
  //   final plainText = MyPrivateKay;
  //   final encrypter = Encrypter(RSA(publicKey: publicKey));
  //
  //   final encrypted = encrypter.encrypt(plainText);
  //   print(encrypted.base64);
  //   return '';
  // }
  //
  //
  // String GetRandomString(int StringLength) {
  //   const _chars =
  //       'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  //   Random _rnd = Random();
  //   String RandStr = String.fromCharCodes(
  //     Iterable.generate(
  //       StringLength,
  //           (_) => _chars.codeUnitAt(
  //         _rnd.nextInt(_chars.length),
  //       ),
  //     ),
  //   );
  //   return RandStr;
  // }
  //
  // Future<bool> SendSessionKayToServer(String Token , String SessionKay)async{
  //   try{
  //     var jsonResponse = await http.post(SendSessionKayRoute,
  //         headers: {
  //           'Accept':'application/json',
  //           'auth_token' : '${Token}'
  //         },
  //         body: {
  //           'key':'${SessionKay}'
  //         }
  //     );
  //     if(jsonResponse.statusCode == 200){
  //       var response = jsonDecode(jsonResponse.body);
  //       message = response['msg'];
  //       if(response['status'] == true){
  //         return true;
  //       }
  //       else{
  //         message = response['msg'];
  //         return false;
  //       }
  //     }else{
  //       message =  'Can not get public server kay ';
  //       return false;
  //     }
  //
  //   }catch(e){
  //     message =  'Can not get public server kay ';
  //     print(e);
  //     return false;
  //   }
  // }
  //
  //

  /** ****************************************************************** */
  /** ------------------------- Digital Signature ---------------------- */
  /** ****************************************************************** */

  /** Handling parameters for Digital Signature */
  Future<bool> HandlingParametersForDigitalSignature(String Token)async{
    ServerPublicKay = await GetPublicServerKay(Token);
    // SharedData sharedData = SharedData();
    if(ServerPublicKay == '')
      return false;
    GenerateAndStorePublicAndPrivateKar();
    // String PublicKay = await sharedData.GetDigitalSignaturePublicKay();
    bool State = await SendPublicKayToServer(Token,publicKey!.toFormattedPEM());
    if(!State){
      // await sharedData.DeleteDigitalSignaturePrivateKay();
      // await sharedData.DeleteDigitalSignaturePublicKay();
      return false;
    }
    return true;
  }

  /** Generate and store public and private kay */

  void GenerateAndStorePublicAndPrivateKar()async{
    RSAKeypair rsaKeypair = RSAKeypair.fromRandom();
    privateKey = rsaKeypair.privateKey;
    publicKey = rsaKeypair.publicKey;
    // SharedData sharedData = SharedData();
    // await sharedData.SaveDigitalSignaturePrivateKay(privateKey!.toPEM());
    // await sharedData.SaveDigitalSignaturePublicKay(publicKey!.toPEM());
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
