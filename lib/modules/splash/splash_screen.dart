import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(
               width: MediaQuery.of(context).size.width * .3,
                 height: MediaQuery.of(context).size.width * .3,
                 decoration: BoxDecoration(
                   image: DecorationImage(
                     image: AssetImage('assets/icons/chat_icon.png'),
                     fit: BoxFit.cover
                   )
                 ),
                 child: null
             ),
             SizedBox(
               height: 50,
             ),
             DefaultTextStyle(
               style: TextStyle(
                 fontSize: 40.0,
                 color: Color(0xffDD5353)
               ),
               child: AnimatedTextKit(
                 animatedTexts: [
                   WavyAnimatedText('Chat YaA'),
                 ],
                 isRepeatingAnimation: true,
                 repeatForever: true,
               ),
             )

           ],
          ),
        ),
      ),
    );
  }
}
