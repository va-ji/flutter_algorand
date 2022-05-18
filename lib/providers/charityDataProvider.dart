import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:algorand_dart/algorand_dart.dart';
import 'package:user_onboarding/helpers/helpers.dart';

import '../providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../models/models.dart';

class CharityDataProvider with ChangeNotifier {
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

  final List<CharityModel> _charities = [];
  List<CharityModel> get charities => [..._charities];

  Algorand? _algorand;
  Algorand? get getAlgoinstance => _algorand;

  var _accountCreated = false;
  bool get isAccountCreated => _accountCreated;

  var _isCharityCreator = false;
  bool get isCharityCreator => _isCharityCreator;

  AccountModel? _currentAccount;
  AccountModel? get getCurrentAccount => _currentAccount;

  final List<CharityCreator> _charityOwners = [];
  List<CharityCreator> get getCharityOwer => [..._charityOwners];

  void addCharities(
      String title, String description, int donation, XFile file) {
    _charities.add(CharityModel(
        title: title,
        description: description,
        donation: donation,
        file: file));
    notifyListeners();
  }

  void isAccountCreator(bool accountType) {
    _isCharityCreator = accountType;
    notifyListeners();
  }

  void setAccountCreation(bool state) {
    _accountCreated = state;
    notifyListeners();
  }

  void setCurrentAccount(AccountModel currentAcc) {
    _currentAccount = currentAcc;
    notifyListeners();
  }

  void addCharityOwner(
      {required AccountModel account, required CharityModel charity}) {
    final ownerModel = CharityCreator(account: account);
    ownerModel.addCharity(charity: charity);
    _charityOwners.add(ownerModel);
    notifyListeners();
  }

  void initAlgorand() {
    _algorand = Algorand(
      algodClient: algodClient,
      indexerClient: indexerClient,
      kmdClient: kmdClient,
    );
  }
}
