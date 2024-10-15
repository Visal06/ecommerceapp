import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mycourse_flutter/api/api_service.dart';
import 'package:mycourse_flutter/model/response/userresponsemodel.dart';
import 'package:mycourse_flutter/model/user.dart';
import 'package:mycourse_flutter/screen/auth/logic/authview.dart';

class Authpresentor {
  final Authview view;
  Authpresentor(this.view);

  Future<void> loginRequest(UserLoginRequest request) async {
    view.onLoading(true);
    try {
      var response = await http.post(Uri.parse(ApiService.loginapi),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));

        view.onLoading(false);
        view.onString('Login Success');
        Userresponse userresponse =
            Userresponse.fromJson(jsonDecode(response.body));
        view.onSuccess(userresponse);
      }
    } catch (e) {
      view.onLoading(false);
    }
  }

  Future<void> registerRequest(UserRegisterRequest requests) async {
    view.onLoading(true);
    try {
      var responses = await http.post(Uri.parse(ApiService.registerapi),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode(requests.toJson()));
      print('object created');
      print(responses.statusCode);
      if (responses.statusCode == 200) {
        print(jsonDecode(responses.body));

        view.onLoading(false);
        view.onString('Register Success');
        Userresponse userresponse =
            Userresponse.fromJson(jsonDecode(responses.body));
        view.onSuccess(userresponse);
      }
    } catch (e) {
      view.onLoading(false);
    }
  }
}
