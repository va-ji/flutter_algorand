import '../../helpers/Logger/logger.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class UserAuth {
  static final UserAuth userAuth = UserAuth._privateConstructor();

  UserAuth._privateConstructor() {
    logger.i("All user auth initialised");
  }
  factory UserAuth() {
    return userAuth;
  }

  Future<SignUpResult> registerUser(
      {required Map<CognitoUserAttributeKey, String> userAtt,
      required String username,
      required String password}) async {
    try {
      return await Amplify.Auth.signUp(
          username: username,
          password: password,
          options: CognitoSignUpOptions(
            userAttributes: userAtt,
          ));
    } on AuthException catch (e) {
      logger.e('Signup error', e.message.toString());
      rethrow;
    }
  }

  Future<SignUpResult> confirmSignUp(String username, String code) async {
    try {
      return await Amplify.Auth.confirmSignUp(
          username: username.trim(), confirmationCode: code.trim());
    } on AuthException catch (e) {
      logger.e('Unable to confirm sign up', e.message);
      rethrow;
    }
  }

  Future<SignInResult> signInUser({
    required String username,
    required String password,
  }) async {
    try {
      return await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
    } on AuthException catch (e) {
      logger.e('Sign in error', e.message);
      rethrow;
    }
  }

  static Future<String?> get accessToken async {
    try {
      AuthSession _session = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      if (_session.isSignedIn == false) {
        return '';
      }

      CognitoAuthSession _authSession = (_session as CognitoAuthSession);
      AWSCognitoUserPoolTokens? _userToken = _authSession.userPoolTokens;

      if (_userToken == null) {
        return '';
      }
      logger.i('user token', _userToken.idToken);
      return _userToken.idToken;
    } catch (e) {
      return '';
    }
  }

  Future<SignOutResult> signOut() async {
    try {
      return await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      logger.i('Cannot Sign out', e.message);
      rethrow;
    }
  }
}
