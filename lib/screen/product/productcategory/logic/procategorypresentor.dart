import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mycourse_flutter/api/api_service.dart';
import 'package:mycourse_flutter/model/response/productbycategorymodel.dart';
import 'package:mycourse_flutter/screen/product/productcategory/logic/procategoryview.dart';

class Procategorypresentor {
  late ProCategoryview view;
  Procategorypresentor(this.view);
  Future<void> proBycategoryid(String id) async {
    try {
      view.onLoading(true);
      var response = await http.get(
        Uri.parse(ApiService.probycategory + id),
        headers: {'Content-type': 'application/json'},
      );
      if (response.statusCode == 200) {
        view.onLoading(false);
        final List<dynamic> body = jsonDecode(response.body);
        List<ProductBycategorymodel> data =
            body.map((data) => ProductBycategorymodel.fromjson(data)).toList();
        // for (int i = 0; i <= data.length; i++) {
        //   print(data[i].name);
        // }
        view.onResponse(data);
      }
      view.onLoading(false);
    } catch (e) {
      view.onLoading(false);
      view.onStringResponse(e.toString());
    }
  }
}
