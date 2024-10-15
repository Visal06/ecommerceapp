import 'package:mycourse_flutter/model/response/userresponsemodel.dart';

abstract class Authview {
  void onLoading(bool loading);
  void onSubmit();
  void onString(String str);
  void onSuccess(Userresponse user);
  void onError(String error);
}
