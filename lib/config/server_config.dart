class ServerConfig{

  // static const ServerDomain = 'http://192.168.114.230:8000';
  // static const ServerDomain = 'http://192.168.37.230:8000';
  static const ServerDomain = 'http://10.0.2.2:8000';

  // auth
  static const RegisterURL = '/api/register';
  static const LoginURL = '/api/login';

  // home
  static const GetUsersURL = '/api/getAllUser';
  static const GetChatsURL = '/api/getChat';

  // chat screen
  static const GetAllMessagesURL = '/api/addChat';

  //Symmetric
  static const SendMessageSymmetricURL = '/api/sendMessage';


  //PGP
  static const GetPublicServerKayURL = '/api/getServerPublicKey';
  static const SendSessionKayURL = '/api/acceptKey';
  static const SendPGPMessageURL = '/api/sendMessage';


  //Digital Signature
  static const SendPublicKayDigitalSignatureURL = '/api/setPub';
  static const SendMessageDigitalSignatureURL = '/api/signature';









}