import 'package:paymentez_flutter/data/paymentez_payment_source.dart';

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
  String funding;
  String fingerprint;
  String country;
  String currency;
  String customerId;
  String cvcCheck;
  List<String> loggingTokens = new List();
  String termination;
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

  @override
  String getId() {
    // TODO: implement getId
  }
}
