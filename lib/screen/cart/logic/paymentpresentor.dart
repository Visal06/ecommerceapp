import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mycourse_flutter/api/api_service.dart';
import 'package:mycourse_flutter/config/authmanager.dart';
import 'package:mycourse_flutter/model/request/paymentrequest.dart';
import 'package:mycourse_flutter/screen/cart/logic/paymentview.dart';

class Paymentpresentor {
  Paymentview view;
  Paymentpresentor(this.view);
  Future<void> paymentprocess(PaymentRequest request) async {
    String? token = await Authmanger.getToken();
    view.onLoading(true);
    try {
      var response = await http.post(
        Uri.parse(ApiService.payment),
        body: jsonEncode(request),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        view.onMessage(result["message"]);
        view.onLoading(false);
      }
    } catch (e) {
      view.onLoading(false);
      view.onMessage("Payment failed. Please try again.");
    }
  }
}
