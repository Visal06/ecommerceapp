import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mycourse_flutter/api/api_service.dart';
import 'package:mycourse_flutter/model/response/productbycategorymodel.dart';
import 'package:mycourse_flutter/screen/product/productdetail/logic/productdetailview.dart';

class Productdetailpresentor {
  final Productdetailview view;
  Productdetailpresentor(this.view);
  Future<void> getProDetail(String id) async {
    try {
      view.onLoading(true);
      var response = await http.get(Uri.parse(ApiService.prodetail + id));
      //print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        ProductBycategorymodel pro = ProductBycategorymodel.fromjson(body);
        // print(pro);
        view.onResponse(pro);
        view.onLoading(false);
      }
    } catch (e) {
      view.onLoading(false);
      print(e.toString());
    }
  }
}
