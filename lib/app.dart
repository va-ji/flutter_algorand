import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'helpers/Logger/logger.dart';
import 'providers/providers.dart';
import 'constants/constants.dart';
import 'routes/routes.dart';
import 'theme/theme.dart';
import './constants/amplifyconfiguration.dart';

class Application extends StatefulWidget {
  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  Routes routerInstance = Routes();
  var _configured = false;

  Future<void> _configureAmplify() async {
    try {
      // Add the following line to add Auth plugin to your app.
      await Amplify.addPlugin(AmplifyAuthCognito());

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
      setState(() {
        _configured = true;
      });
    } on Exception catch (e) {
      logger.e('An error occurred configuring Amplify: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _configureAmplify();
    routerInstance.configureRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CharityDataProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: Constants.debugBanner,
        home: _configured
            ? LoginRouter()
            : const CircularProgressIndicator.adaptive(),
        title: Constants.applicationConstants.title,
        theme: ApplicationTheme(context).getAppTheme,
        onGenerateRoute: routerInstance.router.generator,
      ),
    );
  }
}
