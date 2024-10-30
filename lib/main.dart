import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mycourse_flutter/config/authmanager.dart';
import 'package:mycourse_flutter/model/category.dart';
import 'package:mycourse_flutter/model/response/productbycategorymodel.dart';
import 'package:mycourse_flutter/screen/auth/screen/login.dart';
import 'package:mycourse_flutter/screen/auth/screen/register.dart';
import 'package:mycourse_flutter/screen/cart/screen/cart.dart';
import 'package:mycourse_flutter/screen/category/screen/categories.dart';
import 'package:mycourse_flutter/screen/home/screen/favorite.dart';
import 'package:mycourse_flutter/screen/home/screen/map.dart';
import 'package:mycourse_flutter/screen/home/screen/master.dart';
import 'package:mycourse_flutter/screen/home/screen/notification.dart';
import 'package:mycourse_flutter/screen/home/screen/profile.dart';
import 'package:mycourse_flutter/screen/onboard/screen/onboardsreen.dart';
import 'package:mycourse_flutter/screen/product/productcategory/screen/probycateid.dart';
import 'package:mycourse_flutter/screen/product/productdetail/screen/detialproduct.dart';
import 'package:mycourse_flutter/screen/product/productdetail/screen/productdetail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 230, 228, 234)),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/sigin') {
            return MaterialPageRoute(builder: (context) => const LoginPage());
          }
          if (settings.name == '/signup') {
            return MaterialPageRoute(builder: (context) => const Register());
          }
          if (settings.name == '/mainpage') {
            return MaterialPageRoute(
                builder: (context) => const MasterScreen());
          }
          if (settings.name == '/map') {
            return MaterialPageRoute(builder: (context) => const MapScreen());
          }
          if (settings.name == '/categories') {
            return MaterialPageRoute(
                builder: (context) => const CategoryScreen());
          }
          if (settings.name == '/favorite') {
            return MaterialPageRoute(
                builder: (context) => const FavoriteScreen());
          }
          if (settings.name == '/onboard') {
            return MaterialPageRoute(
                builder: (context) => const OnboardScreen());
          }
          if (settings.name == '/notification') {
            return MaterialPageRoute(
                builder: (context) => const NotificationScreen());
          }
          if (settings.name == '/profile') {
            return MaterialPageRoute(builder: (context) => const ProfilePage());
          }
          if (settings.name == '/cart') {
            return MaterialPageRoute(builder: (context) => const CartPage());
          }
          if (settings.name == '/productcategory') {
            final Categories categ = settings.arguments as Categories;
            return MaterialPageRoute(
                builder: (context) => Probycateidpage(
                      categories: categ,
                    ));
          }
          //route for passing data from one screen to another screen
          if (settings.name == '/productdetail') {
            final ProductBycategorymodel prodetail =
                settings.arguments as ProductBycategorymodel;
            return MaterialPageRoute(
                builder: (context) =>
                    ProductDetailPage(productdetail: prodetail));
          }
          //route for getting data from api directly
          if (settings.name == '/detailproduct') {
            final int id = settings.arguments as int;
            return MaterialPageRoute(
                builder: (context) => Detialproductpage(id: id));
          }
          return null;
        });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isAuth = false;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternetAndLogin();
  }

  Future<void> _checkInternetAndLogin() async {
    // Check internet connection
    var connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasInternet = false;
        isLoading = false;
      });
    } else {
      // If internet is available, check login
      await checklogin();
    }
  }

  Future<void> checklogin() async {
    await Future.delayed(const Duration(seconds: 5));
    String? isToken = await Authmanger.getToken();
    setState(() {
      if (isToken != null) {
        isAuth = true;
        isLoading = false;
      } else {
        isAuth = false;
        isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 24),
          color: const Color.fromARGB(255, 211, 221, 212),
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  "assets/image/logo.png",
                  width: 202,
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Text("v1.2"),
              )
            ],
          ),
        ),
      );
    }

    if (!hasInternet) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, color: Colors.redAccent, size: 100),
              const SizedBox(height: 20),
              const Text('No Internet Connection'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkInternetAndLogin,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    return isAuth ? const OnboardScreen() : const LoginPage();
  }
}
