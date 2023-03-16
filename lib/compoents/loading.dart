import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingMessage{
  void DisplayToast(Color BackgroundColor , Color IndicatorColor , Color TextColor , String MessageText , bool DismissOnTap){
    EasyLoading.instance
      ..backgroundColor = BackgroundColor
      ..indicatorColor = IndicatorColor
      ..textColor =  TextColor;

    EasyLoading.showToast(
      '${MessageText}',
      toastPosition: EasyLoadingToastPosition.bottom,
      dismissOnTap: DismissOnTap,
      duration: Duration(seconds: 5),
    );
  }

  void DisplayInfoMessage(Color BackgroundColor , Color IndicatorColor , Color TextColor , String MessageText , bool DismissOnTap){
    EasyLoading.instance
      ..backgroundColor = BackgroundColor
      ..indicatorColor = IndicatorColor
      ..textColor =  TextColor;
    EasyLoading.showToast(
      '${MessageText}',
      toastPosition: EasyLoadingToastPosition.center,
      dismissOnTap: DismissOnTap,
      duration: Duration(seconds: 5),
      maskType: EasyLoadingMaskType.black,
    );
  }

  void DisplayLoading(Color BackgroundColor , Color IndicatorColor){
    EasyLoading.instance
      ..backgroundColor = BackgroundColor
      ..indicatorColor = IndicatorColor
      ..textColor =  Colors.white;
    EasyLoading.show(
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
    );
  }

  void EndLoading(){
    EasyLoading.dismiss();
  }

  void DisplaySuccess(Color BackgroundColor , Color IndicatorColor , Color TextColor , String MessageText, bool DismissOnTap){
    EasyLoading.instance
      ..backgroundColor = BackgroundColor
      ..indicatorColor = IndicatorColor
      ..textColor =  TextColor;
    EasyLoading.showSuccess(
      MessageText,
      dismissOnTap: DismissOnTap,
      duration: Duration(seconds: 4),
      maskType: EasyLoadingMaskType.black,
    );
  }

  void DisplayError(Color BackgroundColor , Color IndicatorColor, Color TextColor , String MessageText, bool DismissOnTap){
    EasyLoading.instance
      ..backgroundColor = BackgroundColor
      ..indicatorColor = IndicatorColor
      ..textColor =  TextColor;
    EasyLoading.showError(
      MessageText,
      dismissOnTap: DismissOnTap,
      duration: Duration(seconds: 4),
      maskType: EasyLoadingMaskType.black,
    );
  }

  void Dismiss (){
    EasyLoading.dismiss();
  }
}