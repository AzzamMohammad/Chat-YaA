import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../models/person.dart';

class RegisterServer{
  var registerRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.RegisterURL);
  String message = '';

  Future<bool> SendRegisterRequest(Person person )async{
    try{
      var jsonResponse = await http.post(registerRoute,
          headers: {
            'Accept':'application/json',
          },
          body: {
            'phone' : '${person.PhoneNumber}',
            'name' : '${person.Name}',
            'password' : '${person.Password}',
          }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status'] == true){
          message = response['msg'];
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

}