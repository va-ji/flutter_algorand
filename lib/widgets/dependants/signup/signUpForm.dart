import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:user_onboarding/helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../helpers/API/api.dart';
import 'signUpTextfField.dart';
import '../../../models/common/deviceInfo/deviceInfo.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _signUpFormKey = GlobalKey<FormState>();
  final SignUpValues signUpValues = SignUpValues();
  final lastname = FocusNode();
  final email = FocusNode();
  final password = FocusNode();
  final cpassword = FocusNode();
  final number = FocusNode();
  Widget _button(void Function()? onPressed, String label) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2,
              )
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SignupTextField(
            label: 'Name',
            hint: 'John Doe',
            action: TextInputAction.next,
            onSaved: (value) {
              signUpValues.firstname = value;
            },
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(lastname);
            },
            type: TextInputType.text,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the first name';
              }
              return null;
            },
          ),
          SignupTextField(
            focusNode: email,
            label: 'Email',
            hint: 'johndoe@example.com',
            action: TextInputAction.next,
            type: TextInputType.text,
            onSaved: (value) {
              signUpValues.email = value;
              logger.i('Email', signUpValues.email);
            },
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(password);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the email';
              }
              Pattern emailPattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regex = RegExp(emailPattern as String);
              if (!regex.hasMatch(value)) return 'Enter Valid Email';
              return null;
            },
          ),
          SignupTextField(
            focusNode: password,
            label: 'Password',
            hint: 'secretpassword',
            isPassword: true,
            action: TextInputAction.next,
            type: TextInputType.text,
            onSaved: (value) {
              signUpValues.password = value;
              logger.i('Password', signUpValues.password);
            },
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(cpassword);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the password';
              }
              return null;
            },
          ),
          SignupTextField(
            focusNode: cpassword,
            label: 'Confirm Password',
            hint: 'secretpassword',
            isPassword: true,
            action: TextInputAction.next,
            type: TextInputType.text,
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(number);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the confirmation password';
              }
              if (value != signUpValues.password) {
                return 'Passwords don\'t match';
              }
              return null;
            },
          ),
          SignupTextField(
            focusNode: number,
            label: 'Number',
            hint: '412345678',
            action: TextInputAction.done,
            type: TextInputType.number,
            onSaved: (value) {
              signUpValues.number = value;
              logger.i('Number', signUpValues.number);
            },
            onSubmit: (_) {},
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter the number';
              }
              return null;
            },
          ),
          _button(() async {
            if (!_signUpFormKey.currentState!.validate()) {
              return;
            }
            _signUpFormKey.currentState!.save();
            SignUpResult result = await UserAuth().registerUser(
              userAtt: {
                CognitoUserAttributeKey.givenName:
                    signUpValues.firstname!.split(' ')[0].toString(),
                CognitoUserAttributeKey.familyName:
                    signUpValues.firstname!.split(' ').length == 1
                        ? signUpValues.firstname!.split(' ')[0]
                        : signUpValues.firstname!.split(' ')[1],
                CognitoUserAttributeKey.email:
                    signUpValues.email!.trim().toString(),
                CognitoUserAttributeKey.phoneNumber:
                    '+61' + signUpValues.number.toString(),
              },
              username: signUpValues.email!.trim().toString(),
              password: signUpValues.password!.trim().toString(),
            );
            if (result.isSignUpComplete) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User Registered'),
                ),
              );
              Navigator.pushNamed(context,
                  '/confirm/${signUpValues.email}/${signUpValues.password}');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User not registered'),
                ),
              );
              Navigator.of(context).pop();
            }
          }, 'SignUp'),
        ],
      ),
    );
  }
}
