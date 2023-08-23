class IyzicoError {
  int errorCode;
  String errorMessage;
  String errorGroup;

  IyzicoError({required this.errorCode, required this.errorMessage, required this.errorGroup});

  factory IyzicoError.fromJson(Map<String, dynamic> json) {
    return IyzicoError(
      errorCode: json['errorCode'],
      errorMessage: json['errorMessage'],
      errorGroup: json['errorGroup'],
    );
  }
}


