import 'package:mycourse_flutter/model/user.dart';

class Userresponse {
  UserModel? user;
  String? token;

  Userresponse({this.user, this.token});

  Userresponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}
