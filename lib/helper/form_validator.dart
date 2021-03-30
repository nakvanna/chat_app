
class FormValidator {
  passwordValidate (password){
    String message;
    if(password.isEmpty) message = 'Please input your password!';
    else if(password.length < 6) message = 'Password at least 6 characters';
    return message;
  }
  
  rePasswordValidate(first, second){
    return first != second ? 'Password not match!' : null;
  }

  emailValidate(email){
    return email ? null : 'Your email not correct!';
  }

  usernameValidate(username){
    String message;
    if (username != '' && username.length < 5 ) message = 'Username at least 5 characters';
    else if(username == '') message = 'Please input your username';
    return message;
  }
}