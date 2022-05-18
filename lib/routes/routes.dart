import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_onboarding/helpers/helpers.dart';
import 'package:user_onboarding/widgets/common/common.dart';

import '../screens/screens.dart';
import '../helpers/Logger/logger.dart';
export './loginRouter.dart';

class Routes {
  static final FluroRouter _router = FluroRouter();

  Routes() {
    _router.notFoundHandler = Handler(handlerFunc: (context, params) {
      return const Scaffold(
        body: Center(
          child: Text('404'),
        ),
      );
    });
  }

  Future<String> get accessToken async {
    final prefs = await SharedPreferences.getInstance();
    logger.i(prefs.getString('accessToken').toString());
    if (!prefs.containsKey('accessToken')) return '';
    var token = prefs.getString('accessToken');
    return token ?? '';
  }

  Handler unAuthenticatedRoute(Widget screen) {
    return Handler(
      handlerFunc: (context, params) {
        return FutureBuilder(
          future: UserAuth.accessToken,
          builder: (context, tokenSnapshot) {
            if (tokenSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.purple,
                ),
              );
            }
            if (tokenSnapshot.data == '') return screen;

            return Home();
          },
        );
      },
    );
  }

  Handler authenticatedRoute(Widget screen) {
    return Handler(
      handlerFunc: (context, params) {
        return FutureBuilder(
          future: UserAuth.accessToken,
          builder: (context, tokenSnapshot) {
            if (tokenSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.purple,
                ),
              );
            }
            if (tokenSnapshot.data == '') return const WelcomePage();
            return screen;
          },
        );
      },
    );
  }

  void _defineRoute(String route, Handler handler,
      {transitionType = TransitionType.material}) {
    _router.define(route, handler: handler, transitionType: transitionType);
  }

  Handler confirmAccountRoute() {
    return Handler(handlerFunc: (context, params) {
      return ConfirmAccount(
        email: params['email']![0],
        password: params['password']![0],
      );
    });
  }

  void configureRoutes() {
    _defineRoute(
      WelcomePage.route,
      unAuthenticatedRoute(const WelcomePage()),
    );
    _defineRoute(
      Login.route,
      unAuthenticatedRoute(Login()),
    );
    _defineRoute(
      SignUp.route,
      unAuthenticatedRoute(SignUp()),
    );
    _defineRoute(
      ConfirmAccount.route,
      confirmAccountRoute(),
    );
    _defineRoute(
      Home.route,
      authenticatedRoute(Home()),
    );
    _defineRoute(
      CompleteService.route,
      authenticatedRoute(const CompleteService()),
    );

    _defineRoute(
      CharityDes.route,
      authenticatedRoute(const CharityDes()),
    );
    _defineRoute(
      CreateCharity.route,
      authenticatedRoute(const CreateCharity()),
    );
    _defineRoute(
      ChangePassword.route,
      authenticatedRoute(ChangePassword()),
    );
    _defineRoute(
      DevEnvironment.route,
      authenticatedRoute(DevEnvironment()),
    );
  }

  FluroRouter get router => _router;
}
