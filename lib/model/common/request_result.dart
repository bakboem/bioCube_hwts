class RequestResult {
  int statusCode;
  dynamic body;
  String message;
  String? renewedAccessToken;
  String? errorMessage;

  RequestResult(this.statusCode, this.body, this.message,
      {this.renewedAccessToken, this.errorMessage});
}
