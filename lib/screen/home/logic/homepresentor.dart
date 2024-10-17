import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mycourse_flutter/api/api_service.dart';
import 'package:mycourse_flutter/model/response/homeresponseviewmodel.dart';
import 'package:mycourse_flutter/screen/home/logic/homeveiw.dart';

class HomePresemtor {
  late Homeveiw view;
  HomePresemtor(this.view);
  Future<void> getdata() async {
    view.onLoading(true);
    try {
      var response = await http.get(Uri.parse(ApiService.app));

      if (response.statusCode == 200) {
        view.onLoading(false);
        final Map<String, dynamic> body = jsonDecode(response.body);

        final appResponse = HomeResponsemodel.fromJson(body);
        view.onResponse(appResponse);
        // final app = appResponse.slices;
        // for (int i = 0; i <= app.length; i++) {
        //   print(app[i].imageurl);
        // }
      }
    } catch (e) {
      view.onLoading(false);
      view.onStringResponse(e.toString());
    }
  }
}
