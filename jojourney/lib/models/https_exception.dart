class HttpsExceptions implements Exception{

  String errorMessage;

  HttpsExceptions(this.errorMessage);
  @override
  String toString() {
    // TODO: implement toString
    return errorMessage;
  }
}