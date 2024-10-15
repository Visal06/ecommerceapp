import 'package:mycourse_flutter/model/onboard.dart';

abstract class Onboardview {
  void onLoading(bool isLoading);
  void onResponse(List<Onboards> onboards);
  void onFetchError(String message);
}
