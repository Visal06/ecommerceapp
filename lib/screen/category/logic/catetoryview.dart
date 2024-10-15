import 'package:mycourse_flutter/model/category.dart';

abstract class CategoryView {
  void onLoading(bool isLoading);
  void onResponse(List<Categories> categories);
  void onFetchError(String message);
}
