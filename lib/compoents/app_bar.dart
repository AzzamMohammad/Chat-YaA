import 'package:flutter/material.dart';

import '../constants/colors.dart';

AppBar BuildAppBar(BuildContext context , bool AutoBack , String? PageName ){
  return AppBar(
    automaticallyImplyLeading: AutoBack,
    title: PageName != null ? Text(PageName,style: TextStyle(fontSize: 25),):null,
    backgroundColor: Color1,
  );
}