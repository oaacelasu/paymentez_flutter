library paymentez_flutter;

import 'dart:convert';

import 'package:crypto/crypto.dart';

export 'ui/card_widget.dart';

// Based on http://en.wikipedia.org/wiki/Bank_card_number#Issuer_identification_number_.28IIN.29
final List _CARDBRAND_IDENTIFIER_LIST = [
  {"RegExp": new RegExp(r'^3(4|7)'), "CardBrands": CardBrands.AMERICAN_EXPRESS},
  {
    "RegExp": new RegExp(r'^6(0|4|5)(1|4)?(1)?'),
    "CardBrands": CardBrands.DISCOVER
  },
  {"RegExp": new RegExp(r'^35'), "CardBrands": CardBrands.JCB},
  {
    "RegExp": new RegExp(r'^30([0-5]|9)|3(6|8|9)'),
    "CardBrands": CardBrands.DINERS_CLUB
  },
  {"RegExp": new RegExp(r'^4'), "CardBrands": CardBrands.VISA},
  {
    "RegExp": new RegExp(r'^5[1-5]|2[3-6]|27(0|1|20)|22[3-9]|222[1-9]'),
    "CardBrands": CardBrands.MASTERCARD
  },
];

class CardBrands {
  final _value;
  const CardBrands._internal(this._value);
  toString() => '$_value';
  toJson() => '$_value';

  static const AMERICAN_EXPRESS = const CardBrands._internal('ax');
  static const DISCOVER = const CardBrands._internal('dc');
  static const JCB = const CardBrands._internal('jc');
  static const DINERS_CLUB = const CardBrands._internal('di');
  static const VISA = const CardBrands._internal('vi');
  static const MASTERCARD = const CardBrands._internal('mc');
  static const UNKNOWN = const CardBrands._internal('unknown');
}

class PaymentezUtils {
  static const String SERVER_DEV_URL = "https://ccapi-stg.paymentez.com";
  static const String SERVER_PROD_URL = "https://ccapi.paymentez.com";

  static String _getUniqToken(
      String auth_timestamp, String paymentez_client_app_key) {
    String uniq_token_string = paymentez_client_app_key + auth_timestamp;
    return sha256.convert(utf8.encode(uniq_token_string)).toString();
  }

  static String getAuthToken(
      String paymentez_client_app_code, String app_client_key) {
    String auth_timestamp = "${DateTime.now().millisecondsSinceEpoch}";
    String string_auth_token = paymentez_client_app_code +
        ";" +
        auth_timestamp +
        ";" +
        _getUniqToken(auth_timestamp, app_client_key);
    String auth_token = base64Encode(utf8.encode(string_auth_token));
    return auth_token;
  }

  static CardBrands getCardBrand(String number) {
    CardBrands issuer = CardBrands.UNKNOWN;
    var issuerID = number.substring(0, number.length > 6 ? 6 : number.length);
    _CARDBRAND_IDENTIFIER_LIST.forEach((item) {
      if (item["RegExp"].hasMatch(issuerID)) {
        if(issuer == CardBrands.UNKNOWN)
        issuer = item["CardBrands"];
      }
    });
    return issuer;
  }

  static bool validateNumberCard(luhn) {
    luhn = luhn.toString().replaceAll(' ', '');
    var luhnDigit =
        int.parse(luhn.substring(luhn.length - 1, luhn.length), radix: 10);
    var luhnLess = luhn.substring(0, luhn.length - 1);
    return (_calculate(luhnLess) == luhnDigit);
  }

  static int _calculate(luhn) {
    luhn = luhn.toString().replaceAll(' ', '');
    var sum = luhn
        .split("")
        .map((e) => int.parse(e, radix: 10))
        .reduce((a, b) => a + b);

    var delta = [0, 1, 2, 3, 4, -4, -3, -2, -1, 0];
    for (var i = luhn.length - 1; i >= 0; i -= 2) {
      sum += delta[int.parse(luhn.substring(i, i + 1), radix: 10)];
    }

    var mod10 = 10 - (sum % 10);
    return mod10 == 10 ? 0 : mod10;
  }
}
