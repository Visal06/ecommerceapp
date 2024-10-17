import 'package:mycourse_flutter/model/response/homeresponseviewmodel.dart';

abstract class Homeveiw {
  void onLoading(bool loading);
  void onResponse(HomeResponsemodel response);
  void onStringResponse(String str);
}
