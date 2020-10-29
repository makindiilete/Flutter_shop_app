// we implements d Exception interface and implements d toString() method to return a msg
class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  // we define our toString() which will be called from "HttpException.toString()" and returns d exception msg
  @override
  String toString() {
    return message;
  }
}
