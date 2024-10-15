import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mycourse_flutter/api/api_service.dart';
import 'package:mycourse_flutter/model/onboard.dart';
import 'package:mycourse_flutter/screen/onboard/logic/onboardview.dart';

class OnboardPresenter {
  final Onboardview view;

  OnboardPresenter(this.view);

  Future<void> getOnboardData() async {
    view.onLoading(true); // Show loading indicator
    try {
      final response = await http.get(Uri.parse(ApiService.getAllOnboard));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Onboards> onboards =
            data.map((json) => Onboards.fromJson(json)).toList();
        view.onResponse(onboards); // Pass data to the view
      } else {
        view.onFetchError('Error loading data');
      }
    } catch (e) {
      view.onFetchError(e.toString());
    } finally {
      view.onLoading(false); // Hide loading indicator
    }
  }
}
