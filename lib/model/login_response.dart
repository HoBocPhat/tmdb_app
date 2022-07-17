

class LoginResponse{
  LoginResponse(this.success, this.expiresAt, this.requestToken);
  late bool success;
  late String  expiresAt;
  late String requestToken;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(json['success'], json['expires_at'], json['request_token']);
  }
}