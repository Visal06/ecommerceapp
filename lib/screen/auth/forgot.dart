import 'package:flutter/material.dart';
import 'package:mycourse_flutter/screen/auth/login.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.0,
              height: 200.0,
              child: Image.asset('assets/image/logo.png'),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: const Text(
                'Please enter your email address',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0),
              ),
            ),
            const SizedBox(height: 22.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'email@samples.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22.0),
            InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                color: Colors.green,
                width: double.infinity,
                height: 45.0,
                alignment: Alignment.center,
                child: const Text(
                  'Send Reset link',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16.0),
                const Text(
                  'Check your email?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16.0),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
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
}
