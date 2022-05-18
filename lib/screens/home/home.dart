import 'dart:math';
import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter/material.dart';
import 'package:user_onboarding/widgets/widgets.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../screens.dart';
import '../../helpers/Logger/logger.dart';
import '../../constants/constants.dart';

class Home extends StatefulWidget {
  static const String route = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Algorand? _algorand;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _random = Random.secure();
  var _loading = false;
  int? accountId;
  String? accountAdd;
  List<String>? publicSeed;
  // AccountModel? _charityCreatorAcc;
  Account? _acc;

  @override
  void initState() {
    Provider.of<CharityDataProvider>(context, listen: false).initAlgorand();
    loadConstantAddress();
    logger.i('init');
    super.initState();
  }

  Future<String> loadConstantAddress() async {
    setState(() {
      _loading = true;
    });
    _algorand = Provider.of<CharityDataProvider>(context, listen: false)
        .getAlgoinstance;
    if (_algorand == null) {
      throw 'Algorand null exception';
    }
    if (Provider.of<CharityDataProvider>(context, listen: false)
        .isCharityCreator) {
      logger.i('Creator');
      _acc = await Account.fromSeedPhrase(Constants().charCreatorSeed);
      accountId = 2365;
    } else {
      logger.i('service');
      _acc = await Account.fromSeedPhrase(Constants().serviceCompletorSeed);
      accountId = 5646;
    }

    publicSeed = await _acc!.seedPhrase;
    final accModel = AccountModel(
        account: _acc!,
        accountId: accountId!,
        publicAddrs: _acc!.publicAddress,
        seedPhrase: publicSeed!);
    Provider.of<CharityDataProvider>(context, listen: false)
        .setCurrentAccount(accModel);
    setState(() {
      _loading = false;
    });
    logger.i('Account address', _acc!.publicAddress);
    logger.i('Account ID', accountId);

    return 'Done';
  }

  // Future<void> createAlgorandAccount() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   _algorand = Provider.of<CharityDataProvider>(context, listen: false)
  //       .getAlgoinstance;
  //   if (_algorand == null) {
  //     throw 'Algorand null exception';
  //   }
  //   final account = await _algorand!.createAccount();

  //   publicSeed = await account.seedPhrase;
  //   accountAdd = account.publicAddress;
  //   accountId = _random.nextInt(10000);
  //   _charityCreatorAcc = AccountModel(
  //       account: account,
  //       accountId: accountId!,
  //       publicAddrs: accountAdd!,
  //       seedPhrase: publicSeed!);
  //   setState(() {
  //     _loading = false;
  //     Provider.of<CharityDataProvider>(context, listen: false)
  //         .setAccountCreation(true);
  //     Provider.of<CharityDataProvider>(context, listen: false)
  //         .setCurrentAccount(_charityCreatorAcc!);
  //   });

  //   logger.i('Account created');
  //   logger.i('Account address', accountAdd);
  //   logger.i('Account seed', publicSeed);
  //   logger.i('Account ID', accountId);
  // }

  // Future<void> loadAccountfromId() async {
  //   String? id;
  //   setState(() {
  //     _loading = true;
  //   });
  //   Provider.of<CharityDataProvider>(context, listen: false).initAlgorand();
  //   _algorand = Provider.of<CharityDataProvider>(context, listen: false)
  //       .getAlgoinstance;
  //   if (_algorand == null) {
  //     throw 'Algorand null exception';
  //   }
  //   final accId = await showDialog<int>(
  //       context: context,
  //       builder: (context) => SimpleDialog(
  //             title: const Text('Load from account id'),
  //             children: [
  //               Form(
  //                 key: _key,
  //                 child: TextFormField(
  //                   decoration: const InputDecoration(
  //                       helperText: 'Account id',
  //                       hintText: 'Enter account id here',
  //                       border: InputBorder.none),
  //                   onSaved: (value) {
  //                     id = value;
  //                   },
  //                   validator: (value) {
  //                     if (value!.isEmpty) return 'Cannot keep value empty';
  //                   },
  //                 ),
  //               ),
  //               ElevatedButton(
  //                   onPressed: () {
  //                     if (!_key.currentState!.validate()) return;
  //                     _key.currentState!.save();
  //                     Navigator.pop(context, int.parse(id!));
  //                   },
  //                   child: const Text('Load Account'))
  //             ],
  //           ));

  //   logger.i('acc id', accId);
  //   final seedForAccount =
  //       Provider.of<CharityDataProvider>(context, listen: false)
  //           .getAccounts
  //           .firstWhere((model) => model.accountId == accId)
  //           .seedPhrase;
  //   final account = await Account.fromSeedPhrase(seedForAccount);
  //   setState(() {
  //     _loading = false;
  //     Provider.of<CharityDataProvider>(context, listen: false)
  //         .setAccountCreation();
  //   });

  //   logger.i('Account created');
  //   logger.i('Account address', accountAdd);
  //   logger.i('Account ID', accountId);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.purple,
              ),
            )
          : Stack(
              children: [
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: Colors.black54),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: MediaQuery.of(context).size.width / 5,
                  child: const Text(
                    'Account Details',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // Provider.of<CharityDataProvider>(context).isAccountCreated
                //     ?
                Positioned(
                  top: 150,
                  left: MediaQuery.of(context).size.width / 7,
                  child: SizedBox(
                    height: 550,
                    width: 300,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 15,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    Provider.of<CharityDataProvider>(context)
                                            .isCharityCreator
                                        ? const AssetImage(
                                            'lib/assets/charity/avatar1.png')
                                        : const AssetImage(
                                            'lib/assets/charity/avatar2.png'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'User id: $accountId',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Account address: ${_acc!.publicAddress}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Public seed: ${publicSeed!.join()}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}


    // : Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Center(
                    //         child: InkWell(
                    //           child: Container(
                    //             alignment: Alignment.center,
                    //             height: 200,
                    //             width:
                    //                 MediaQuery.of(context).size.width / 1.1,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(
                    //                   color: Colors.blueGrey, width: 5),
                    //               borderRadius: BorderRadius.circular(12),
                    //               color: Colors.blueAccent,
                    //             ),
                    //             child: const Padding(
                    //               padding: EdgeInsets.all(1.0),
                    //               child: Text(
                    //                 'Create an account',
                    //                 style: TextStyle(
                    //                     color: Colors.white, fontSize: 40),
                    //                 softWrap: true,
                    //               ),
                    //             ),
                    //           ),
                    //           onTap: () async {
                    //             await createAlgorandAccount();
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),