import 'dart:convert';

import 'package:mycourse_flutter/model/response/userresponsemodel.dart';
import 'package:mycourse_flutter/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authmanger {
  static Future<void> saveUserToken(Userresponse userToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(userToken.user);
    String? isToken = userToken.token;
    await prefs.setString('user', userJson);
    await prefs.setString('token', isToken!);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    if (token != null) {
      return token;
    }
    return null;
  }

  static Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userTokenJson = prefs.getString('user');
    if (userTokenJson == null) {
      return null;
    }
    Map<String, dynamic> userTokenMap = jsonDecode(userTokenJson);
    UserModel? user = UserModel.fromJson(userTokenMap);
    return user;
  }

  static Future<void> removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("user");
    await preferences.remove("token");
    await preferences.remove("cart_items");
    await preferences.remove("favorites");
  }
}
