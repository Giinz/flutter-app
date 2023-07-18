//Login exceptions

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//Register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidemailAuthException implements Exception {}

//Generic exceptions

class GenericlAuthException implements Exception {}

class UserNotLoggedinAuthException implements Exception {}
