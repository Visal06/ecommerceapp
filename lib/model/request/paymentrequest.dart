import 'package:mycourse_flutter/model/cart_item.dart';

class PaymentRequest {
  final String holdername;
  final String acc;
  final String dates;
  final String cvc;
  final String amount;
  final String address;
  final String phone;
  final String payby;
  final List<CartItem> product;

  PaymentRequest({
    required this.holdername,
    required this.acc,
    required this.dates,
    required this.cvc,
    required this.amount,
    required this.address,
    required this.phone,
    required this.payby,
    required this.product,
  });

  Map<String, dynamic> toJson() {
    return {
      'holdername': holdername,
      'acc': acc,
      'dates': dates,
      'cvc': cvc,
      'amount': amount,
      'address': address,
      'phone': phone,
      'payby': payby,
      'product': product
    };
  }

  factory PaymentRequest.formJson(Map<String, dynamic> json) {
    return PaymentRequest(
        holdername: json['holdername'],
        acc: json['acc'],
        dates: json['dates'],
        cvc: json['cvc'],
        amount: json['amount'],
        address: json['address'],
        phone: json['phone'],
        payby: json['payby'],
        product: json['product']);
  }
}
