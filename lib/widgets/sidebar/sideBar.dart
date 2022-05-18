import 'package:flutter/material.dart';
import 'package:user_onboarding/helpers/helpers.dart';

import '../../providers/providers.dart';

class Sidebar extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(50), bottomRight: Radius.circular(40)),
        child: Drawer(
          child: Material(
            color: Colors.grey[50],
            child: ListView(
              children: <Widget>[
                SizedBox(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildMenuCategory('Account'),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            tooltip: 'close',
                            color: Colors.blue,
                            iconSize: 30,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        // padding: padding,
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            const Divider(
                              height: 1,
                            ),
                            buildMenuItem(
                              text: 'Home',
                              icon: const Icon(
                                Icons.home,
                                color: Colors.blue,
                              ),
                              onClicked: () =>
                                  {Navigator.pushNamed(context, '/home')},
                            ),
                            buildMenuItem(
                              text: 'Charity Creator',
                              icon: const Icon(
                                Icons.create_rounded,
                                color: Colors.blue,
                              ),
                              onClicked: Provider.of<CharityDataProvider>(
                                          context)
                                      .isCharityCreator
                                  ? () =>
                                      {Navigator.pushNamed(context, '/charity')}
                                  : null,
                            ),
                            const Divider(
                              height: 1,
                            ),
                            buildMenuItem(
                                text: 'Charity completor',
                                icon: const Icon(
                                  Icons.work_rounded,
                                  color: Colors.blue,
                                ),
                                onClicked:
                                    (!Provider.of<CharityDataProvider>(context)
                                            .isCharityCreator)
                                        ? () => {
                                              Navigator.pushNamed(
                                                  context, '/service')
                                            }
                                        : null),
                            const Divider(
                              height: 1,
                            ),
                            buildMenuItem(
                              text: 'Log out',
                              icon: const Icon(
                                Icons.logout_sharp,
                                color: Colors.blue,
                              ),
                              onClicked: () async {
                                await Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .logout(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      //buildLogOut(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;
    const hoverColor = Colors.black12;

    return ListTile(
      leading: icon,
      title: Text(text, style: const TextStyle(color: color, fontSize: 14)),
      hoverColor: hoverColor,
      tileColor: Colors.white,
      onTap: onClicked,
    );
  }

  Widget buildMenuCategory(name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      alignment: Alignment.topLeft,
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          letterSpacing: 0.29,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildLogOut(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton.icon(
          icon: const Icon(
            Icons.logout_sharp,
            color: Colors.blue,
          ),
          label: const Text(
            'Log out',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            Provider.of<CharityDataProvider>(context).setAccountCreation(false);
            Navigator.of(context).popUntil((route) => route.isFirst);
            await UserAuth().signOut();
          },
        ),
      ],
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        break;
      case 1:
        break;
    }
  }
}
