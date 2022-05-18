import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_onboarding/screens/completeService/completeService.dart';
import 'package:user_onboarding/screens/createCharity/createCharity.dart';
import 'package:user_onboarding/screens/home/home.dart';

import '../../../constants/constants.dart';
import '../../../helpers/helpers.dart';
import '../../../providers/providers.dart';
import '../../../models/models.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final double height;
  const LoginForm({
    required this.formKey,
    required this.height,
  });
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _passwordFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final LoginAPIBody loginValues = LoginAPIBody();
  var cardOne = false;
  var cardTwo = false;

  Widget _textField(
    String title, {
    bool isPassword = false,
    String? hintText,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    void Function(String?)? onSaved,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: onSaved,
            keyboardType: keyboardType,
            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            obscureText: isPassword,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              fillColor: const Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _loginButton(void Function()? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.purple, Colors.blueAccent])),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _textField(
          "Email id",
          focusNode: _usernameFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          hintText: 'JohnDoe@example.com',
          keyboardType: TextInputType.emailAddress,
          onSaved: (value) {
            loginValues.username = value;
          },
          validator: (value) {
            if (value!.isEmpty) return 'Please Enter the Email';
            if (!TextHelper().validateEmail(value)) return 'Enter Valid Email';
            return null;
          },
        ),
        _textField(
          "Password",
          isPassword: true,
          focusNode: _passwordFocusNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          onSaved: (value) {
            loginValues.password = value;
          },
          validator: (value) {
            if (value!.isEmpty) return 'Please enter the password';
            return null;
          },
        ),
      ],
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Charity',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: const [
            TextSpan(
              text: 'On',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            TextSpan(
              text: 'Blocks',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(
            'or',
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/signup');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Signup',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardWidget(String asset, String title, double padding,
      {required Function()? ontap, required var cardno}) {
    return SizedBox(
      height: 250,
      width: 185,
      child: InkWell(
        child: Card(
          color: cardno ? Colors.greenAccent : Colors.white,
          shadowColor: Colors.white38,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 10,
          child: Column(
            children: [
              FittedBox(
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        onTap: ontap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void performLogin(
        Function assignToken, Function changeFirstLoginStatus) async {
      if (widget.formKey.currentState == null) {
        debugPrint('emptyformkey');
      } else if (widget.formKey.currentState!.validate()) {
        widget.formKey.currentState!.save();
        SignInResult response;

        response = await UserAuth().signInUser(
            username: loginValues.username!, password: loginValues.password!);

        if (response.isSignedIn) {
          final token = await UserAuth.accessToken;
          assignToken(token);
          if (cardOne) {
            Provider.of<CharityDataProvider>(context, listen: false)
                .isAccountCreator(true);
          }
          if (cardTwo) {
            Provider.of<CharityDataProvider>(context, listen: false)
                .isAccountCreator(false);
          }
          Navigator.of(context).pushNamed(Home.route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not signed in'),
            ),
          );
        }
      }
    }

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 70,
          ),
          _title(),

          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                cardWidget(
                    'lib/assets/charity/avatar1.png', 'Create a charity', 20,
                    ontap: () {
                  setState(() {
                    cardOne = true;
                    cardTwo = false;
                  });
                  logger.i(cardOne);
                }, cardno: cardOne),
                cardWidget(
                    'lib/assets/charity/avatar2.png', 'Complete a charity', 5,
                    ontap: () {
                  setState(() {
                    cardOne = false;
                    cardTwo = true;
                  });
                }, cardno: cardTwo),
              ],
            ),
          ),
          _emailPasswordWidget(),
          Consumer<UserDataProvider>(
            builder: (_, data, __) => _loginButton(
              () {
                if (Constants.bypassBackend) {
                  data.assignAccessToken(Constants.devAccessToken);
                  Navigator.of(context).pushReplacementNamed('/home');
                  return;
                }
                performLogin(
                    data.assignAccessToken, data.changeFirstLoginStatus);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerRight,
            child: const Text('Forgot Password ?',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          _divider(),
          // SizedBox(height: widget.height * .005),
          _createAccountLabel(),
        ],
      ),
    );
  }
}
