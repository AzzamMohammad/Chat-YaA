import 'package:flutter/material.dart';

class MyThemes {

  //////////////////// light color //////////////////////////////

  // App bar
  static final AppBarBackgroundWightColor = Color(0xffDD5353);
  static final AppBarTitleWightColor = Colors.white;
  static final AppBarIconWightColor = Colors.white;

  // scaffold
  static final ScaffoldBackgroundWightColor = Colors.white;//Color(0xffeadcd0)



  // // Bottom Bar
  // static final BottomBarBackgroundWightColor = Color(0xff076579);
  // static final UnselectedItemColor = Color(0xff9ad5e1);
  // static final SelectedItemColor = Colors.white;


  static final mainLightColor = Color(0xffB73E3E); //Color(0xff05445E)
  // static final secondlyLightColor = Color(0xff017b91);
  // static final mainDarkColor = Color(0xff017b91);
  // static final secondlyDarkColor = Color(0xff9ad5e1);
  // static final IconColor = Colors.white;


  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: ScaffoldBackgroundWightColor,

      colorScheme: ColorScheme.light(),
      //text color
      fontFamily: "Cairo",
      primaryColor: mainLightColor,
      //color we can use when we need

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Colors.red
      ),

      iconTheme: IconThemeData(color: mainLightColor, size: 20),

      listTileTheme: ListTileThemeData(
        iconColor: mainLightColor,
        selectedTileColor: Color(0xffEDDBC0),
        textColor: Color(0xffB73E3E)
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: Color(0xffeadcd0),
        scrimColor: Color(0x5fb73e3e),
      ),


      appBarTheme: AppBarTheme(
        backgroundColor: AppBarBackgroundWightColor,


        titleTextStyle: TextStyle(
            color: AppBarTitleWightColor, fontSize: 30, fontFamily: "Cairo"),
        actionsIconTheme: IconThemeData(
            color: AppBarIconWightColor,
            size: 30
        ),
        iconTheme: IconThemeData(
          color: AppBarIconWightColor,
          size: 30,
        ),

      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateColor.resolveWith((states) => AppBarBackgroundWightColor),
      ),


      inputDecorationTheme: InputDecorationTheme(


        labelStyle: TextStyle(
          color: mainLightColor,
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: mainLightColor,
              width: 2
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        suffixIconColor: mainLightColor,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.red,
              width: 2
          ),
          borderRadius: BorderRadius.circular(8),
        ),


        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: mainLightColor,
              width: 2
          ),

          borderRadius: BorderRadius.circular(8),
        ),


        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.red,
              width: 3
          ),

          borderRadius: BorderRadius.circular(8),
        ),
        errorMaxLines: 1,

      ),
      elevatedButtonTheme: ElevatedButtonThemeData(

          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xffB73E3E)),
            minimumSize: MaterialStateProperty.all<Size>(Size(10, 50)),
            maximumSize: MaterialStateProperty.all<Size>(Size(400, 50)),
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(fontSize: 15,color:Color(0xffDD5353),),),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                side: BorderSide(width: 2 , color: Color(0xffB73E3E)),
                borderRadius: BorderRadius.all(Radius.circular(5),),),),
          )
      ),
      // bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //   backgroundColor: BottomBarBackgroundWightColor,
      //   unselectedItemColor: UnselectedItemColor,
      //   selectedItemColor: SelectedItemColor,
      // )

  );
}
