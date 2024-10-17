import 'package:flutter/material.dart';
import 'package:mycourse_flutter/config/authmanager.dart';
import 'package:mycourse_flutter/model/response/userresponsemodel.dart';
import 'package:mycourse_flutter/model/user.dart';
import 'package:mycourse_flutter/screen/auth/logic/authpresentor.dart';
import 'package:mycourse_flutter/screen/auth/logic/authview.dart';
import 'package:mycourse_flutter/screen/auth/screen/forgot.dart';
import 'package:mycourse_flutter/screen/auth/screen/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements Authview {
  TextEditingController userController =
      TextEditingController(text: 'khunvisalcute9@gmail.com');
  TextEditingController passwordController =
      TextEditingController(text: '12345678');
  bool isErro = false;
  late Authpresentor presentor;
  UserModel? userModel;
  bool loadin = false;
  String responsetext = '';
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    presentor = Authpresentor(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loadin
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200.0,
                    height: 200.0,
                    child: Image.asset('assets/image/solo logo.png'),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Welcome to the Keels Login page',
                    style: TextStyle(
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  const SizedBox(height: 22.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: userController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: buildPasswordField(),
                  ),
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: onSubmit,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      width: double.infinity,
                      height: 45.0,
                      alignment: Alignment.center,
                      color: Colors.green,
                      child: const Text(
                        'Signin',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPage()));
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }

  bool validateEmail() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (userController.text.isEmpty) {
      showError("Email is required");
      return false;
    }
    if (!emailRegex.hasMatch(userController.text)) {
      showError("Invalid email format");
      return false;
    }
    return true;
  }

  bool validatePassword() {
    if (passwordController.text.isEmpty) {
      showError("Password is required");
      return false;
    }
    if (passwordController.text.length < 6) {
      showError("Password must be at least 8 characters long");
      return false;
    }
    return true;
  }

  void showError(String message) {
    // Show an alert dialog with the error message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          icon: const Icon(
            Icons.info,
            color: Colors.red,
            size: 46,
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onLoading(bool loading) {
    setState(() {
      loadin = loading;
    });
  }

  @override
  void onSubmit() {
    if (validateEmail() && validatePassword()) {
      setState(() {
        UserLoginRequest request = UserLoginRequest();
        request.email = userController.text;
        request.password = passwordController.text;
        presentor.loginRequest(request);
      });
    }
  }

  @override
  void onString(String str) {
    setState(() {
      responsetext = str;
    });
  }

  @override
  void onSuccess(Userresponse userresponse) {
    setState(() {
      userModel = userresponse.user;
      Authmanger.saveUserToken(userresponse);
      Navigator.pushReplacementNamed(context, '/onboard');
    });
  }

  @override
  void onError(String error) {
    setState(() {
      isErro = true;
      showError(error);
    });
  }
}
