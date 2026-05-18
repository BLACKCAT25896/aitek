class EmailChecker {
  static bool isNotValid(String email) {
    return !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}

bool isValidDomain(String domain) {
  final domainRegex = RegExp(
      r'^(?!-)([A-Za-z0-9-]{1,63}\.)+[A-Za-z]{2,}$'
  );
  return domainRegex.hasMatch(domain.trim());
}
