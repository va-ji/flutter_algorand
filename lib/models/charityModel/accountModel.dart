import 'package:algorand_dart/algorand_dart.dart';

class AccountModel {
  final List<String> seedPhrase;
  final String publicAddrs;
  final Account account;
  final int accountId;

  AccountModel({
    required this.account,
    required this.accountId,
    required this.publicAddrs,
    required this.seedPhrase,
  });
}
