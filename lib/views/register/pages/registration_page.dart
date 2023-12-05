import 'package:flutter/material.dart';

import 'package:sih_app/api/api.dart';
import 'package:sih_app/helpers/navigator_helper.dart';
import 'package:sih_app/modal/rest_response.dart';
import 'package:sih_app/utils/components/flut_toast.dart';
import 'package:sih_app/utils/const.dart';

import 'package:sih_app/utils/components/my_button.dart';
import 'package:sih_app/utils/components/my_textfield.dart';

import 'package:sih_app/views/login/pages/login_page.dart';

bool isLoading = false;

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final appName = AppConst().appName;

  final fullnameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  pushToLogin(BuildContext context) {
    if (context.mounted)
      NavigationHelper.navigateToSecondRoute(context, LoginPage());
  }

  // sign user in method
  Future<RestResponse> signUserIn({username, email, pass}) async {
    var api = API();
    RestResponse resp =
        await api.signup(username: username, email: email, pass: pass);
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.app_registration,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Welcome to ${appName}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: fullnameController,
                  hintText: 'Full Name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // forgot password?

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  isLoading: isLoading,
                  buttonName: "Sign Up",
                  onTap: () async {
                    if (fullnameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      showToast("Please fill all fields");
                      return;
                    }
                    bool isEmailValid = RegExp(
                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                        .hasMatch(emailController.text);
                    if (!isEmailValid) {
                      showToast("Please enter a valid email");
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });
                    RestResponse resp = await signUserIn(
                        username: fullnameController.text,
                        email: emailController.text,
                        pass: passwordController.text);
                    if (resp.status == 200) {
                      showToast("You account has been created. Kindly login");
                      setState(() {
                        isLoading = false;
                      });
                      if (context.mounted) {
                        Future.delayed(Duration(seconds: 1))
                            .then((value) => pushToLogin(context));
                      }
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      showToast(resp.detail);
                    }
                  },
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
