import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class VerifyConnectionPage extends StatefulWidget {
  @override
  _VerifyConnectionPageState createState() => _VerifyConnectionPageState();
}

class _VerifyConnectionPageState extends State<VerifyConnectionPage>
    with SingleTickerProviderStateMixin {
  bool isConnected = false;
  bool isChecking = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    setState(() {
      isChecking = true;
    });
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isConnected = true;
        isChecking = false;
      });
      _navigateToMainPage();
    } else {
      setState(() {
        isConnected = false;
        isChecking = false;
      });
    }
  }

  void _navigateToMainPage() {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: isChecking
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.5 + _animationController.value * 0.5,
                          child: Icon(
                            Icons.wifi,
                            color: Colors.blueAccent,
                            size: 100,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Checking your connection...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: Colors.redAccent,
                      size: 100,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'No Internet Connection',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Please check your connection and try again.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _checkInternetConnection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Page')),
      body: Center(
        child: Text('You are connected to the internet!'),
      ),
    );
  }
}
