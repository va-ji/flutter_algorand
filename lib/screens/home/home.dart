import 'package:flutter/material.dart';
import '../../helpers/Logger/logger.dart';

import '../../providers/providers.dart';
import '../screens.dart';
import '../../routes/routes.dart';

class Home extends StatefulWidget {
  static const String route = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User OnBoarding'),
        actions: <Widget>[
          GestureDetector(
              onTap: () {},
              child: Consumer<UserDataProvider>(
                  builder: (context, data, __) => TextButton(
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          data.logout(context);
                        },
                      )))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
              width: 150,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CreateCharity.route);
                  },
                  child: const Text(
                    "Create a charity",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              width: 170,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CompleteService.route);
                  },
                  child: const Text(
                    "Complete a service",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
