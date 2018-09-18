import 'package:paymentez_flutter/data/card.dart';
import 'package:paymentez_flutter/utils/text_utils.dart';

String getPossibleCardType(String cardNumber, {bool type = true}) {
  return _getPossibleCardType(cardNumber, type);
}

String _getPossibleCardType(String cardNumber, bool shouldNormalize) {
  if (isBlank(cardNumber)) {
    return Card.CARDBRAND_UNKNOWN;
  }

  String spacelessCardNumber = cardNumber;
  if (shouldNormalize) {
    spacelessCardNumber = removeSpacesAndHyphens(cardNumber);
  }

  if (hasAnyPrefix(spacelessCardNumber, Card.PREFIXES_AMERICAN_EXPRESS)) {
    return Card.CARDBRAND_AMEX;
  } else if (hasAnyPrefix(spacelessCardNumber, Card.PREFIXES_DISCOVER)) {
    return Card.CARDBRAND_DISCOVER;
  } else if (hasAnyPrefix(spacelessCardNumber, Card.PREFIXES_JCB)) {
    return Card.CARDBRAND_JCB;
  } else if (hasAnyPrefix(spacelessCardNumber, Card.PREFIXES_DINERS_CLUB)) {
    return Card.CARDBRAND_DINERS;
  } else if (hasAnyPrefix(spacelessCardNumber, Card.PREFIXES_VISA)) {
    return Card.CARDBRAND_VISA;
  } else if (hasAnyPrefix(spacelessCardNumber, Card.PREFIXES_MASTERCARD)) {
    return Card.CARDBRAND_MC;
  } else {
    return Card.CARDBRAND_UNKNOWN;
  }
}
