String nullIfBlank(String value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return null;
  }
  return value;
}

bool isBlank(String value) {
  return value == null ? true : value.trim().length == 0;
}

String removeSpacesAndHyphens(String cardNumberWithSpaces) {
  if (isBlank(cardNumberWithSpaces)) {
    return null;
  }
  return cardNumberWithSpaces.replaceAll("\\s|-", "");
}

hasAnyPrefix(String number, List<String> prefixes) {
  if (number == null) {
    return false;
  }

  prefixes.forEach((prefix) {
    if (number.startsWith(prefix)) {
      return true;
    }
  });

  return false;
}
