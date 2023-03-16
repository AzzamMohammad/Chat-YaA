import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secur_chat/provider/provider_setting.dart';

import 'binding/home_binding.dart';
import 'binding/login_binding.dart';
import 'binding/messages_chat_binding.dart';
import 'binding/register_binding.dart';
import 'binding/splash_binding.dart';
import 'modules/home/home_screen.dart';
import 'modules/login/login_screen.dart';
import 'modules/messages_chat/messages_chat_screen.dart';
import 'modules/register/register_screen.dart';
import 'modules/splash/splash_screen.dart';

void main() {
  runApp(
      GetMaterialApp(
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        getPages:[
          // auth
          GetPage(name: '/splash', page: () => SplashScreen(), binding: SplashBinding()),
          GetPage(name: '/register', page: () => RegisterScreen(), binding: RegisterBinding()),
          GetPage(name: '/login', page: () => LoginScreen(), binding: LoginBinding()),

          //home
          GetPage(name: '/home', page: () => HomeScreen(), binding: HomeBinding()),

          // messages
          GetPage(name: '/messages_chat', page: () => MessagesChatScreen(), binding: MessagesChatBinding()),


        ],
        builder: EasyLoading.init(),
      )
  );
  ConfigEasyLoading();

}


void ConfigEasyLoading(){
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 20)
    ..indicatorType = EasyLoadingIndicatorType.foldingCube
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50
    ..radius = 10.0
    ..progressColor = Colors.green
    ..maskColor = Colors.blue
    ..userInteractions = false
    ..dismissOnTap = false;

}
