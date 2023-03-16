import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:secur_chat/config/server_config.dart';

class PusherConfig{
  static const appIp = '1529101';
  static const kay = 'a597e6eefd1b80e12bd2';
  static const secret = '08a0fafe3c1d7d6cb649';
  static const cluster = 'ap1';
  static const hostEndPint = ServerConfig.ServerDomain;
  static const hostAuthEndPint = '${hostEndPint}/broadcasting/auth';
  static const port = 6001;
}


class LaravelEcho {
  static LaravelEcho? _singleton;
  static late Echo _echo;
  final String Token;

  LaravelEcho._({
    required this.Token
}) {
    _echo = CreateLaravelEcho(Token);
  }

  factory LaravelEcho.init({
    required String Token,
}){
    if(_singleton == null || Token != _singleton?.Token) {
      _singleton = LaravelEcho._(Token: Token);
    }
    return _singleton!;
  }

  static Echo get instance => _echo;

  static String get SocketId => _echo.socketId() ?? "11111.11111111";
}

PusherClient CreatePusherClient(String Token){
  PusherOptions options = PusherOptions(
    wsPort:  PusherConfig.port,
    encrypted: true,
    host: PusherConfig.hostEndPint,
    cluster:  PusherConfig.cluster,
  );

  PusherClient pusherClient = PusherClient(
    PusherConfig.kay,
    options,
    autoConnect: true,
    enableLogging: true
  );

  return pusherClient;
}

Echo CreateLaravelEcho(String Token){
  return Echo(
    client: CreatePusherClient(Token),
    broadcaster: EchoBroadcasterType.Pusher,
  );
}