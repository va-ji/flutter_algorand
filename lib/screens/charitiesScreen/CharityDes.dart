import 'dart:convert';
import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/constants.dart';
import '../../widgets/widgets.dart';
import '../../providers/providers.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class CharityDes extends StatefulWidget {
  static const route = '/charity';
  const CharityDes({Key? key}) : super(key: key);

  @override
  State<CharityDes> createState() => _CharityDesState();
}

class _CharityDesState extends State<CharityDes> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _textAssetName = TextEditingController();
  final _textUnitName = TextEditingController();
  final _textDescription = TextEditingController();
  final _textIpfsUrl = TextEditingController();
  final _textPrice = TextEditingController();
  final _focusUnitName = FocusNode();
  final _focusDescription = FocusNode();
  final _focusipfs = FocusNode();
  final _focusPrice = FocusNode();
  String? assetName;
  String? unitName;
  String? description;
  String? url;
  int? price;
  int? assetId;
  XFile? image;
  var _assetCreated = false;
  var _loading = false;
  late Algorand _algorand;
  AssetConfigTransaction? _tx;

  Future<void> sendToescrow() async {
    logger.i("asset Id", assetId);
    if (assetId == null) {
      throw 'Asset id is null';
    }
    const escrowAccountAddr = Constants.escrowadd;
    final algorand = Provider.of<CharityDataProvider>(context, listen: false)
        .getAlgoinstance;
    final accountModel =
        Provider.of<CharityDataProvider>(context, listen: false)
            .getCurrentAccount;
    try {
      await algorand!.assetManager.transfer(
        assetId: assetId!,
        account: accountModel!.account,
        receiver: Address.fromAlgorandAddress(address: escrowAccountAddr),
        amount: 1,
      );

      final transactionId = await algorand.sendPayment(
        account: accountModel.account,
        recipient: Address.fromAlgorandAddress(address: escrowAccountAddr),
        amount: Algo.toMicroAlgos(price!.toDouble()),
        note: 'Charity: $assetName',
        waitForConfirmation: true,
        timeout: 3,
      );

      logger.i('Transaction id:', transactionId);
    } on AlgorandException catch (e) {
      logger.e('Alogrand error', e.message.toString());
    }

    logger.i('sent asset to escrow acc');
  }

  Future<void> createCharityAsset() async {
    if (_key.currentState == null) {
      throw 'form is null';
    } else {
      _key.currentState!.save();

      final accountModel =
          Provider.of<CharityDataProvider>(context, listen: false)
              .getCurrentAccount;
      final params = await _algorand.getSuggestedTransactionParams();
      final metaData = {
        "standard": "arc69",
        "description": description ?? '',
        "external_url": url ?? '',
        "mime_type": "plain/text",
      };
      final metaHash = Uint8List.fromList(sha256
          .convert(utf8.encode(const JsonEncoder().convert(metaData)))
          .bytes);
      //transaction id: 86437063
      try {
        _tx = await (AssetConfigTransactionBuilder()
              ..sender = accountModel!.account.address
              ..totalAssetsToCreate = 1
              ..decimals = 0
              ..unitName = unitName
              ..assetName = assetName
              ..url = url ?? ''
              ..metaData = metaHash
              ..defaultFrozen = false
              ..managerAddress = accountModel.account.address
              ..reserveAddress = accountModel.account.address
              ..suggestedParams = params)
            .build();
        if (_tx == null) {
          throw 'Transaction is null';
        }
        // Sign the transaction
        final signedTx = await _tx!.sign(accountModel.account);
        signedTx.signature;
        final txId = await _algorand.sendTransaction(signedTx);
        final response = await _algorand.waitForConfirmation(txId);
        assetId = response.assetIndex;
        logger.i('response', response.assetIndex);

        _assetCreated = true;
      } on AlgorandException catch (e) {
        logger.i("Couldnt transfer asset to escrow account", e.message);
      }

      if (_assetCreated) {
        _assetCreated = false;
        // final charity = CharityModel(
        //     title: assetName!,
        //     description: description!,
        //     donation: price!,
        //     file: image!);

        // Provider.of<CharityDataProvider>(context, listen: false)
        //     .addCharities(assetName!, description!, price!, image!);
        // Provider.of<CharityDataProvider>(context, listen: false)
        //     .addCharityOwner(account: accountModel!, charity: charity);
      }
    }
  }

  @override
  void initState() {
    _algorand = Provider.of<CharityDataProvider>(context, listen: false)
        .getAlgoinstance!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final charity = ModalRoute.of(context)!.settings.arguments as CharityModel;
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: const Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey, Colors.black54]),
                  ),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(image: AssetImage(charity.path!)
                    //       // FileImage(
                    //       //   File(charity.file.path),
                    //       // ),
                    //       ),
                    // ),
                    child: Column(
                      children: [
                        Image.asset(charity.path!),
                        Positioned(
                          top: 250,
                          left: MediaQuery.of(context).size.width / 18,
                          child: SizedBox(
                            height: 550,
                            width: 370,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Form(
                                    key: _key,
                                    child: Column(
                                      children: [
                                        FormWidget(
                                            controller: _textAssetName,
                                            focusNode: _focusUnitName,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            label: 'Asset Name',
                                            onSaved: (value) {
                                              assetName = value;
                                            }),
                                        FormWidget(
                                            controller: _textUnitName,
                                            focusNode: _focusDescription,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            label: 'Unit Name',
                                            onSaved: (value) {
                                              unitName = value;
                                            }),
                                        FormWidget(
                                            controller: _textIpfsUrl,
                                            focusNode: _focusipfs,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            label: 'Ipfs Url',
                                            onSaved: (value) {
                                              url = value;
                                            }),
                                        FormWidget(
                                            controller: _textDescription,
                                            focusNode: _focusPrice,
                                            keyboardType:
                                                TextInputType.multiline,
                                            textInputAction:
                                                TextInputAction.next,
                                            label: 'Description',
                                            onSaved: (value) {
                                              description = value;
                                            }),
                                        FormWidget(
                                          controller: _textPrice,
                                          focusNode: null,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                          label: 'Price',
                                          onSaved: (value) {
                                            price = int.parse(value!);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Container(
                                        height: 70,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.black, width: 2),
                                          color: Colors.lightBlue,
                                        ),
                                        child: const Center(
                                            child: Text(
                                          'Create digital Asset',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          _loading = true;
                                        });
                                        await createCharityAsset();
                                        setState(() {
                                          _loading = false;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Container(
                                        height: 70,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.black, width: 2),
                                          color: Colors.lightBlue,
                                        ),
                                        child: const Center(
                                            child: Text(
                                          'Send Asset to charity escrow',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          _loading = true;
                                        });
                                        await sendToescrow();
                                        setState(() {
                                          _loading = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
