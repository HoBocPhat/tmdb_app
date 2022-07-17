import 'package:tmdb_app/auth/form_submit_status.dart';

class LoginState{
  final String username;
  bool get isValidUsername => username.isNotEmpty;
  final String password;
  bool get isValidPassword => password.isNotEmpty;
  final String token;
  final FormSubmissionStatus formStatus;
  final bool doLogin;

  LoginState({this.username = '',
    this.password = '',
    this.token = '',
    this.formStatus = const InitialFormStatus(),
    this.doLogin = false
  });

  LoginState copyWith({
    String? username,
    String? password,
    String? token,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      token: token ?? this.token,
      formStatus: formStatus ?? this.formStatus
    );
  }

  LoginState logout(
      bool? doLogin
      ) {
    return LoginState(
      doLogin: doLogin ?? this.doLogin
    );
  }

}