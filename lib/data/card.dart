import 'package:paymentez_flutter/assets.dart';
import 'package:paymentez_flutter/data/paymentez_payment_source.dart';
import 'package:paymentez_flutter/utils/card_utils.dart';
import 'package:paymentez_flutter/utils/text_utils.dart';

class Card implements PaymentezPaymentSource {
  Card({
    this.number,
    this.expiryMonth,
    this.expiryYear,
    this.cvc,
    this.holderName,
    this.addressLine1,
    this.addressLine2,
    this.addressCity,
    this.addressState,
    this.addressZip,
    this.addressCountry,
    this.type,
    this.last4,
    this.fingerprint,
    this.funding,
    this.country,
    this.currency,
    this.id,
  });

  factory Card.build(
          String number,
          int expMonth,
          int expYear,
          String cvc,
          String name,
          String addressLine1,
          String addressLine2,
          String addressCity,
          String addressState,
          String addressZip,
          String addressCountry,
          String type,
          String last4,
          String fingerprint,
          String funding,
          String country,
          String currency,
          String id) =>
      new Card(
        number: normalizeCardNumber(number),
        expiryMonth: expMonth,
        expiryYear: expYear,
        cvc: nullIfBlank(cvc),
        holderName: nullIfBlank(name),
        addressLine1: nullIfBlank(addressLine1),
        addressLine2: nullIfBlank(addressLine2),
        addressCity: nullIfBlank(addressCity),
        addressState: nullIfBlank(addressState),
        addressZip: nullIfBlank(addressZip),
        addressCountry: nullIfBlank(addressCountry),
        type: asCardBrand(type) == null ? getType(id, number) : type,
        last4: nullIfBlank(last4) == null ? getLast4(last4, number) : last4,
        fingerprint: nullIfBlank(fingerprint),
        funding: asFundingType(funding),
        country: nullIfBlank(country),
        currency: nullIfBlank(currency),
        id: nullIfBlank(id),
      );

  static const Map<String, String> BRAND_RESOURCE_MAP = {
    CARDBRAND_AMEX: ImageAssets.amex,
    CARDBRAND_MC: ImageAssets.mastercard,
    CARDBRAND_DINERS: ImageAssets.generic,
    CARDBRAND_VISA: ImageAssets.visa,
    CARDBRAND_JCB: ImageAssets.generic,
    CARDBRAND_DISCOVER: ImageAssets.generic,
    CARDBRAND_UNKNOWN: ImageAssets.generic,
  };

  static const int CVC_LENGTH_AMERICAN_EXPRESS = 4;
  static const int CVC_LENGTH_COMMON = 3;
  // Based on http://en.wikipedia.org/wiki/Bank_card_number#Issuer_identification_number_.28IIN.29
  static const List<String> PREFIXES_AMERICAN_EXPRESS = ["34", "37"];
  static const List<String> PREFIXES_DISCOVER = ["60", "62", "64", "65"];
  static const List<String> PREFIXES_JCB = ["35"];
  static const List<String> PREFIXES_DINERS_CLUB = [
    "300",
    "301",
    "302",
    "303",
    "304",
    "305",
    "309",
    "36",
    "38",
    "39"
  ];
  static const List<String> PREFIXES_VISA = ["4"];
  static const List<String> PREFIXES_MASTERCARD = [
    "2221",
    "2222",
    "2223",
    "2224",
    "2225",
    "2226",
    "2227",
    "2228",
    "2229",
    "223",
    "224",
    "225",
    "226",
    "227",
    "228",
    "229",
    "23",
    "24",
    "25",
    "26",
    "270",
    "271",
    "2720",
    "50",
    "51",
    "52",
    "53",
    "54",
    "55"
  ];

  static const int MAX_LENGTH_STANDARD = 16;
  static const int MAX_LENGTH_AMERICAN_EXPRESS = 15;
  static const int MAX_LENGTH_DINERS_CLUB = 14;

  static const String VALUE_CARD = "card";

  static const String FIELD_OBJECT = "object";
  static const String FIELD_ADDRESS_CITY = "address_city";
  static const String FIELD_ADDRESS_COUNTRY = "address_country";
  static const String FIELD_ADDRESS_LINE1 = "address_line1";
  static const String FIELD_ADDRESS_LINE1_CHECK = "address_line1_check";
  static const String FIELD_ADDRESS_LINE2 = "address_line2";
  static const String FIELD_ADDRESS_STATE = "address_state";
  static const String FIELD_ADDRESS_ZIP = "address_zip";
  static const String FIELD_ADDRESS_ZIP_CHECK = "address_zip_check";
  static const String FIELD_BRAND = "type";
  static const String FIELD_COUNTRY = "country";
  static const String FIELD_CURRENCY = "currency";
  static const String FIELD_CUSTOMER = "customer";
  static const String FIELD_CVC_CHECK = "cvc_check";
  static const String FIELD_EXP_MONTH = "exp_month";
  static const String FIELD_EXP_YEAR = "exp_year";
  static const String FIELD_FINGERPRINT = "fingerprint";
  static const String FIELD_FUNDING = "funding";
  static const String FIELD_NAME = "holderName";
  static const String CARDBRAND_VISA = 'vi';
  static const String CARDBRAND_MC = 'mc';
  static const String CARDBRAND_JCB = 'jcb';
  static const String CARDBRAND_AMEX = 'ax';
  static const String CARDBRAND_DISCOVER = 'dc';
  static const String CARDBRAND_DINERS = 'di';
  static const String CARDBRAND_UNKNOWN = "unknown";
  static const String FIELD_LAST4 = "last4";
  static const String FIELD_ID = "id";
  static const String FUNDING_CREDIT = 'credit';
  static const String FUNDING_DEBIT = 'debit';
  static const String FUNDING_PREPAID = 'prepaid';
  static const String FUNDING_UNKNOWN = 'unknown';

  String addressLine1;
  String addressLine1Check;
  String addressLine2;
  String addressCity;
  String addressState;
  String addressZip;
  String addressZipCheck;
  String addressCountry;
  String last4;

//   FundingType
  String funding;
  String fingerprint;
  String country;
  String currency;
  String customerId;
  String cvcCheck;

  List<String> loggingTokens = new List();

  String termination;

//  @CardBrand
  String type;

  int expiryMonth;

  int expiryYear;

  String bin;

  String status;

  String number;

  String token;

  String cvc;
  String id;

  String holderName;

  String transactionReference;

  String message;

//  Map<String, dynamic> toJSON() => <String, dynamic>{
//        'id': this.id,
//        'status': this.status,
//        'lastdigits': this.lastdigits,
//        'brand': this.brand,
//        'is_default': this.is_default,
//      };
//
//  Map<String, dynamic> toAddCardJSON() => <String, dynamic>{
//        'reference': this.reference,
//        'is_default': this.is_default,
//      };
//
//  factory Card.fromJSON(Map<String, dynamic> json) => new Card(
//        id: json['id'],
//        status: json['status'],
//        lastdigits: json['lastdigits'],
//        brand: json['brand'],
//        is_default: json['is_default'],
//      );

//  @override
//  bool operator ==(Object other) =>
//      identical(this, other) ||
//      other is Card &&
//          runtimeType == other.runtimeType &&
//          id == other.id &&
//          status == other.status &&
//          lastdigits == other.lastdigits &&
//          brand == other.brand &&
//          is_default == other.is_default;
//
//  @override
//  int get hashCode =>
//      id.hashCode ^
//      status.hashCode ^
//      lastdigits.hashCode ^
//      brand.hashCode ^
//      is_default.hashCode;

  @override
  String getId() {
    // TODO: implement getId
  }

  static String normalizeCardNumber(String number) {
    if (number == null) {
      return null;
    } else if (number.isEmpty) {
      return null;
    }
    return number.trim().replaceAll("\\s+|-", "");
  }

  static String asCardBrand(String possibleCardType) {
    if (nullIfBlank(possibleCardType.trim()) == null) {
      return null;
    }

    if (CARDBRAND_AMEX == possibleCardType.toLowerCase()) {
      return CARDBRAND_AMEX;
    } else if (CARDBRAND_MC == possibleCardType.toLowerCase()) {
      return CARDBRAND_MC;
    } else if (CARDBRAND_DINERS == possibleCardType.toLowerCase()) {
      return CARDBRAND_DINERS;
    } else if (CARDBRAND_VISA == possibleCardType.toLowerCase()) {
      return CARDBRAND_VISA;
    } else if (CARDBRAND_DISCOVER == possibleCardType.toLowerCase()) {
      return CARDBRAND_DISCOVER;
    } else if (CARDBRAND_JCB == possibleCardType.toLowerCase()) {
      return CARDBRAND_JCB;
    } else {
      return CARDBRAND_UNKNOWN;
    }
  }

  static String getType(String type, String number) {
    if (isBlank(type) && !isBlank(number)) {
      type = getPossibleCardType(number);
    }
    return type;
  }

  static String getLast4(String last4, String number) {
    if (!isBlank(last4)) {
      return last4;
    }

    if (number != null && number.length >= 4) {
      last4 = number.substring(number.length - 4, number.length);
      return last4;
    }

    return null;
  }

  static String asFundingType(String possibleFundingType) {
    if (nullIfBlank(possibleFundingType.trim()) == null) {
      return null;
    }

    if (Card.FUNDING_CREDIT == possibleFundingType.toLowerCase()) {
      return Card.FUNDING_CREDIT;
    } else if (Card.FUNDING_DEBIT == possibleFundingType.toLowerCase()) {
      return Card.FUNDING_DEBIT;
    } else if (Card.FUNDING_PREPAID == possibleFundingType.toLowerCase()) {
      return Card.FUNDING_PREPAID;
    } else {
      return Card.FUNDING_UNKNOWN;
    }
  }
}
