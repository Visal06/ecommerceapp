import 'package:mycourse_flutter/model/response/productbycategorymodel.dart';

abstract class Productdetailview {
  void onLoading(bool loading);
  void onResponse(ProductBycategorymodel response);
  void onStringResponse(String str);
}
