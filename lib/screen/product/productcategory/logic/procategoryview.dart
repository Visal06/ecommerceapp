import 'package:mycourse_flutter/model/response/productbycategorymodel.dart';

abstract class ProCategoryview {
  void onLoading(bool loading);
  // void onResponse(ProductBycategorymodel response);
  void onResponse(List<ProductBycategorymodel> response);
  void onStringResponse(String str);
}
