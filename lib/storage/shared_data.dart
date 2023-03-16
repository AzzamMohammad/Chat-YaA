import 'package:shared_preferences/shared_preferences.dart';

class SharedData{
  ///////////// token
   Future<void> SaveToken(String Token)async{
    final data = await SharedPreferences.getInstance();
    data.setString('token', Token);
  }

  Future<String> GetToken()async{
    final data = await SharedPreferences.getInstance();
    String? token = data.getString('token');
    return token ?? '';
  }
  Future<bool> DeleteToken ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('token'))
      return true;
    return false;
  }


  /////////////////// phone
  Future<void> SavePhoneNumber(String PhoneNumber)async{
    final data = await SharedPreferences.getInstance();
    data.setString('phone_number', PhoneNumber);
  }

  Future<String> GetPhoneNumber()async{
    final data = await SharedPreferences.getInstance();
    String? PhoneNumber = data.getString('phone_number');
    return PhoneNumber ?? '';
  }
  Future<bool> DeletePhoneNumber ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('phone_number'))
      return true;
    return false;
  }

  /////////////////// password
  Future<void> SavePassword(String password)async{
    final data = await SharedPreferences.getInstance();
    data.setString('password', password);
  }

  Future<String> GetPassword()async{
    final data = await SharedPreferences.getInstance();
    String? password = data.getString('password');
    return password ?? '';
  }
  Future<bool> DeletePassword ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('password'))
      return true;
    return false;
  }


  /////////////////// Id
  Future<void> SaveId(int Id)async{
    final data = await SharedPreferences.getInstance();
    data.setInt('Id', Id);
  }

  Future<int> GetId()async{
    final data = await SharedPreferences.getInstance();
    int? Id = data.getInt('Id');
    return Id ?? -1;
  }
  Future<bool> DeleteId ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('Id'))
      return true;
    return false;
  }


  /////////////////// SecretKay
  Future<void> SaveSecretKay(int PhoneNumber)async{
     int Akay = PhoneNumber % 10;
     int Bkay = PhoneNumber % 100;
     int Ckay = PhoneNumber % 1000;
     int Dkay = PhoneNumber % 1000000;
    final data = await SharedPreferences.getInstance();
    data.setString('secret_kay', 'A${Akay}B${Bkay}C${Ckay}D${Dkay}');
  }

  Future<String> GetSecretKay()async{
    final data = await SharedPreferences.getInstance();
    String? SecretKay = data.getString('secret_kay');
    return SecretKay ?? '';
  }
  Future<bool> DeleteSecretKay ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('secret_kay'))
      return true;
    return false;
  }

  /////////////////// PGPPrivateKay
  Future<void> SavePGPPrivateKay(String PGPPrivateKay)async{
    final data = await SharedPreferences.getInstance();
    data.setString('PGP_private_kay', PGPPrivateKay);
  }

  Future<String> GetPGPPrivateKay()async{
    final data = await SharedPreferences.getInstance();
    String? PGPPrivateKay = data.getString('PGP_private_kay');
    return PGPPrivateKay ?? '';
  }
  Future<bool> DeletePGPPrivateKay ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('PGP_private_kay'))
      return true;
    return false;
  }

  /////////////////// DigitalSignaturePrivateKay
  Future<void> SaveDigitalSignaturePrivateKay(String DigitalSignaturePrivateKay)async{
    final data = await SharedPreferences.getInstance();
    data.setString('digital_signature_private_kay', DigitalSignaturePrivateKay);
  }

  Future<String> GetDigitalSignaturePrivateKay()async{
    final data = await SharedPreferences.getInstance();
    String? DigitalSignaturePrivateKay = data.getString('digital_signature_private_kay');
    return DigitalSignaturePrivateKay ?? '';
  }
  Future<bool> DeleteDigitalSignaturePrivateKay ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('digital_signature_private_kay'))
      return true;
    return false;
  }

  /////////////////// DigitalSignaturePublicKay
  Future<void> SaveDigitalSignaturePublicKay(String DigitalSignaturePublicKay)async{
    final data = await SharedPreferences.getInstance();
    data.setString('digital_signature_public_kay', DigitalSignaturePublicKay);
  }

  Future<String> GetDigitalSignaturePublicKay()async{
    final data = await SharedPreferences.getInstance();
    String? DigitalSignaturePublicKay = data.getString('digital_signature_public_kay');
    return DigitalSignaturePublicKay ?? '';
  }
  Future<bool> DeleteDigitalSignaturePublicKay ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('digital_signature_public_kay'))
      return true;
    return false;
  }

}