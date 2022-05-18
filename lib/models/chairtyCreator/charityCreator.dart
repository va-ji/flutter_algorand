import '../../models/charityModel/accountModel.dart';
import '../../models/charityModel/charityModel.dart';

class CharityCreator {
  final AccountModel account;
  final List<CharityModel> charities = [];

  CharityCreator({required this.account});

  void addCharity({required CharityModel charity}) {
    charities.add(charity);
  }
}
