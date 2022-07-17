abstract class LoginEvent{}

class LoginUsernameChange extends LoginEvent {
  final String username;
  LoginUsernameChange(this.username,);
}

class LoginPasswordChange extends LoginEvent {
  final String password;
  LoginPasswordChange(this.password);
}

class LoginTokenChange extends LoginEvent {
  final String token;
  LoginTokenChange(this.token);
}

class LoginSubmitted extends LoginEvent{
  final String username;
  final String password;
  LoginSubmitted(this.username,this.password);
}

class LoginFingerPrint extends LoginEvent {

}

// class Logout extends LoginEvent {
//   Logout();
// }


