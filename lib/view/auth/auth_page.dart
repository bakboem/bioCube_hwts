/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/view/auth/auth_page.dart
 * Created Date: 2023-02-01 10:56:03
 * Last Modified: 2023-02-22 22:44:46
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:hwst/globalProvider/auth_provider.dart';
import 'package:hwst/view/home/home_page.dart';
import 'package:hwst/view/signin/signin_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Selector<AuthProvider, bool>(
      selector: (context, provider) => provider.isLogedin,
      builder: (context, isLogedin, _) {
        return isLogedin ? HomePage() : SigninPage();
      },
    );
  }
}
