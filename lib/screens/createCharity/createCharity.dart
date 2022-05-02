import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:algorand_dart/algorand_dart.dart';

import '../../constants/constants.dart';
import '../../helpers/Logger/logger.dart';

class KeyModel {
  final String publicAddress;
  final List<String> mnemonic;
  KeyModel({required this.publicAddress, required this.mnemonic});
}

class CreateCharity extends StatefulWidget {
  static const route = '/charity';
  const CreateCharity({Key? key}) : super(key: key);

  @override
  State<CreateCharity> createState() => _CreateCharityState();
}

class _CreateCharityState extends State<CreateCharity> {
  String? _publicAddress;
  Account?
      _account; //J6HBFQVQGJV5LBDVOZWGRJ5JYPDV55CCFE26GB4VHBPRODTKVAXV4Q7PHU
  List<String>? _seed = [
    'achieve',
    'occur',
    'various',
    'speak',
    'normal',
    'owner',
    'bargain',
    'sauce',
    'voice',
    'excess',
    'skill',
    'illegal',
    'traffic',
    'mule',
    'stove',
    'entry',
    'butter',
    'green',
    'scale',
    'pear',
    'motor',
    'blood',
    'that',
    'about',
    'carpet'
  ];
  // final Address _escrowAccountAdd = Address(
  //     publicKey: Uint8List.fromList(
  //         '2RB4VJM252ANMH3RZF7GOVNVB2K3D4CDUSW2FLAFORVTPP5UCO4T4ZFQ4Q'
  //             .codeUnits));
  @override
  Widget build(BuildContext context) {
    final algodClient = AlgodClient(
      apiUrl: PureStake.TESTNET_ALGOD_API_URL,
      apiKey: Constants.apiKey,
      tokenKey: PureStake.API_TOKEN_HEADER,
    );

    final indexerClient = IndexerClient(
      apiUrl: PureStake.TESTNET_INDEXER_API_URL,
      apiKey: Constants.apiKey,
      tokenKey: PureStake.API_TOKEN_HEADER,
    );

    final kmdClient = KmdClient(
      apiUrl: '127.0.0.1',
      apiKey: Constants.apiKey,
    );

    final algorand = Algorand(
      algodClient: algodClient,
      indexerClient: indexerClient,
      kmdClient: kmdClient,
    );

    Future<KeyModel> createAccount(Account account) async {
      final seed = await account.seedPhrase;
      final model =
          KeyModel(publicAddress: account.publicAddress, mnemonic: seed);
      return model;
    }

    Future<void> createCharityAsset() async {
      final params = await algorand.getSuggestedTransactionParams();

      // Create the asset
      //transaction id: 86437063
      try {
        final tx = await (AssetConfigTransactionBuilder()
              ..sender = _account!.address
              ..totalAssetsToCreate = 1
              ..decimals = 0
              ..unitName = 'Rubbish'
              ..assetName = 'Cleaning out the rubbish'
              ..url =
                  'https://ipfs.io/ipfs/QmNek7wVeksgqb3jKyduoahMu5ECvbFjSsGTpowndHtdiu?filename=rubbishcharity.jpg'
              // ..metadataB64 = 'location 8C Lancaster avenue Newcomb'
              ..defaultFrozen = false
              ..managerAddress = _account!.address
              ..reserveAddress = _account!.address
              ..freezeAddress = _account!.address
              ..clawbackAddress = _account!.address
              ..suggestedParams = params)
            .build();

        // Sign the transaction
        if (_account == null) {
          logger.i("Account null");
          return;
        }
        final signedTx = await tx.sign(_account!);
        signedTx.signature;
        final txId = await algorand.sendTransaction(signedTx);
        final response = await algorand.waitForConfirmation(txId);
        logger.i('response', response.assetIndex);
      } on AlgorandException catch (e) {
        logger.i("Couldnt transfer asset to escrow account", e.message);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create charity'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                  onPressed: () async {
                    _account = await algorand.createAccount();
                    final modelData = await createAccount(_account!);
                    _publicAddress = modelData.publicAddress;
                    _seed = modelData.mnemonic;
                    // _account = await Account.fromSeedPhrase(_seed!);
                    // _publicAddress = _account!.publicAddress;
                    logger.i('Public address of charity owner', _publicAddress);
                    // logger.i('Seed Phrase', _seed);
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.black),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () async {
                  await createCharityAsset();
                },
                child: const Text(
                  'Create digital charity',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
