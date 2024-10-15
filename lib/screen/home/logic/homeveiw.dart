import 'package:mycourse_flutter/model/response/appresponseviewmodel.dart';

abstract class Homeveiw {
  void onLoading(bool loading);
  void onResponse(AppResponsemodel response);
  void onStringResponse(String str);
}
