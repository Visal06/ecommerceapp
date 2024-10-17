import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:mycourse_flutter/config/authmanager.dart';
import 'package:mycourse_flutter/model/response/userresponsemodel.dart';
import 'package:mycourse_flutter/model/user.dart';
import 'package:mycourse_flutter/screen/auth/logic/authpresentor.dart';
import 'package:mycourse_flutter/screen/auth/logic/authview.dart';
import 'package:mycourse_flutter/screen/auth/screen/otp_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> implements Authview {
  late Authpresentor presentor;
  late final UserModel? userModel;
  late bool loading;
  late String responsetext;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  EmailOTP myauth = EmailOTP();

  @override
  void initState() {
    super.initState();
    presentor = Authpresentor(this);
  }

  Future<void> _handleOtpVerification() async {
    if (validateName() &&
        validatePassword() &&
        validateConfirmPassword() &&
        validateEmail()) {
      setState(() {
        UserRegisterRequest request = UserRegisterRequest(
          name: nameController.text,
          email: emailController.text,
          email_verified_at: passwordController.text,
          password: passwordController.text,
        );
        presentor.registerRequest(request);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 150.0,
              height: 150.0,
              child: Image.asset('assets/image/solo logo.png'),
            ),
            const Text(
              'Register before continuing',
              style: TextStyle(
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            const SizedBox(height: 25.0),
            _buildTextField(nameController, 'Username'),
            const SizedBox(height: 16.0),
            _buildTextField(passwordController, 'Password', obscureText: true),
            const SizedBox(height: 16.0),
            _buildTextField(confirmPasswordController, 'Confirm Password',
                obscureText: true),
            const SizedBox(height: 16.0),
            _buildTextField(emailController, 'Email'),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () async {
                myauth.setConfig(
                  appEmail: "khunvisalcute9@gmail.com",
                  appName: "Email OTP",
                  userEmail: emailController.text,
                  otpLength: 4,
                  otpType: OTPType.digitsOnly,
                );
                if (await myauth.sendOTP()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("OTP has been sent")),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(
                        myauth: myauth,
                        onOtpVerified: () async {
                          await _handleOtpVerification(); // Handle registration after OTP verification
                        },
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Oops, OTP send failed")),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                width: double.infinity,
                height: 45.0,
                alignment: Alignment.center,
                color: Colors.green,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already signed up?",
                  style: TextStyle(
                      color: Color.fromARGB(255, 3, 3, 3),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Back to login',
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

//set sample textfield controllers properties for the sample
  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool obscureText = false}) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
        ),
      ),
    );
  }

  bool validateName() {
    if (nameController.text.isEmpty) {
      showError("Name is required");
      return false;
    }
    return true;
  }

  bool validatePassword() {
    if (passwordController.text.isEmpty) {
      showError("Password is required");
      return false;
    }
    if (passwordController.text.length < 8) {
      showError("Password must be at least 8 characters long");
      return false;
    }
    return true;
  }

  bool validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      showError("Confirm password is required");
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showError("Passwords do not match");
      return false;
    }
    return true;
  }

  bool validateEmail() {
    if (emailController.text.isEmpty) {
      showError("Email is required");
      return false;
    }
    if (!emailController.text.contains('@')) {
      showError("Invalid email format");
      return false;
    }
    return true;
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void onError(String error) {}

  @override
  void onLoading(bool loading) {
    setState(() {
      this.loading = loading;
    });
  }

  @override
  void onString(String str) {
    setState(() {
      responsetext = str;
    });
  }

//it's not used for there is verifying with OTP-Screen
  @override
  void onSubmit() {
    if (validateName() &&
        validatePassword() &&
        validateConfirmPassword() &&
        validateEmail()) {
      setState(() {
        UserRegisterRequest request = UserRegisterRequest(
          name: nameController.text,
          email: emailController.text,
          email_verified_at: passwordController.text,
          password: passwordController.text,
        );
        presentor.registerRequest(request);
      });
    }
  }

  @override
  void onSuccess(Userresponse userresponse) {
    setState(() {
      userModel = userresponse.user;
      Authmanger.saveUserToken(userresponse);
    });
  }
}
