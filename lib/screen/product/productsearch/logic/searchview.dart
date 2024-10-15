import 'package:mycourse_flutter/model/response/productbysearchmodel.dart';

abstract class ProductSearchview {
  void onLoading(bool loading);
  void onResponse(List<Productbysearchmodel> response);
  void onStringResponse(String str);
}
