import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Otp extends StatefulWidget {
  const Otp({
    super.key,
    required this.otpController,
  });
  final TextEditingController otpController;

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: widget.otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: '0',
        ),
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.myauth,
    required this.onOtpVerified,
  });
  final EmailOTP myauth;
  final VoidCallback onOtpVerified;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();

  @override
  void dispose() {
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final otp = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text;

    final isVerified = await widget.myauth.verifyOTP(otp: otp);

    if (isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP is verified")),
      );
      widget.onOtpVerified(); // Call the callback function
      Navigator.pushReplacementNamed(context, '/onboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP, check your email address!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/solo logo.png',
              width: 100.0,
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter Verification Code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Otp(otpController: otp1Controller),
                Otp(otpController: otp2Controller),
                Otp(otpController: otp3Controller),
                Otp(otpController: otp4Controller),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Please check your email address!",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 45.0),
              ),
              child: const Text(
                'Verify Now',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
