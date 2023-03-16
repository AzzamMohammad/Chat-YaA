import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secur_chat/modules/register/register_controller.dart';
import '../../compoents/loading.dart';
import '../../constants/colors.dart';
import '../../storage/shared_data.dart';

class RegisterScreen extends StatelessWidget {


  final RegisterController registerController = Get.find();
  final formKay = GlobalKey<FormState>();
  final IsHead = true.obs;
  final IsSave = false.obs;
  final LoadingMessage loadingMessage = LoadingMessage();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(6),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width * .2,
            ),
            Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/icons/chat_icon.png'),
                        fit: BoxFit.contain
                    )
                ),
                child: null
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'REGISTER',
                style: TextStyle(
                  color: Color1,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * .2,
            ),
            Form(
              key: formKay,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    controller: registerController.NameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Name';
                      }else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      registerController.UserName = value!;
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    maxLines: 1,
                    controller: registerController.PhoneNumberController,
                    decoration: InputDecoration(
                      labelText: "Phone number",
                    ),
                    validator: (value) {

                      if (value!.isEmpty) {
                        return 'Enter Your phone number';
                      }
                        else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      registerController.PhoneNumber = value!;
                    },
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Obx(() {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      controller: registerController.PassWordController,
                      obscureText: IsHead.value,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: IsHead.value
                              ? Icon(
                            Icons.visibility_off,
                            size: 20,
                          )
                              : Icon(
                            Icons.visibility,
                            size: 20,
                          ),
                          onPressed: () {
                            IsHead(!IsHead.value);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your password";
                        } else if (value.length < 8) {
                          return "Password most be more tha 8 characters";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        registerController.UserPassword = value!;
                      },
                    );
                  }),
                  SizedBox(
                    height: 17,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Text(
                  //           "Remember me",
                  //           style: TextStyle(fontSize: 15),
                  //         ),
                  //         SizedBox(
                  //           width: 10,
                  //         ),
                  //         Obx(() {
                  //           return GestureDetector(
                  //             onTap: () {
                  //               IsSave(!IsSave.value);
                  //             },
                  //             child: Container(
                  //               width: 22,
                  //               height: 22,
                  //               decoration: BoxDecoration(
                  //                   borderRadius:
                  //                   BorderRadius.all(Radius.circular(7)),
                  //                   border: Border.all(
                  //                       color: Theme.of(context).primaryColor,
                  //                       width: 3),
                  //                   color: IsSave.value == false
                  //                       ? Theme.of(context).scaffoldBackgroundColor
                  //                       : Theme.of(context).primaryColor),
                  //               child: Icon(
                  //                 Icons.check,
                  //                 color: IsSave.value == false
                  //                     ? Theme.of(context).scaffoldBackgroundColor
                  //                     : Colors.white,
                  //                 size: 17,
                  //               ),
                  //             ),
                  //           );
                  //         }),
                  //       ],
                  //     ),
                  //
                  //   ],
                  //
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final isValid = formKay.currentState?.validate();
                      if (isValid == true) {
                        formKay.currentState?.save();
                        if (IsSave.value) {
                          registerController.sharedData.SavePhoneNumber(registerController.PhoneNumber);
                          registerController.sharedData.SavePassword(registerController.UserPassword);
                        }
                        OnClickLogin(context);
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 50)),
                      maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 50)),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text('Go to'),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/login');
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  void OnClickLogin(BuildContext context)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );

    await registerController.RegisterClicked();

    if (registerController.state) {
      loadingMessage.Dismiss();
      Get.offAllNamed('/login');
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          registerController.message,
          true);
    }
  }

}
