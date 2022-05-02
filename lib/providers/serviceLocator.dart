import 'package:algorand_dart/algorand_dart.dart';

class ServiceLocator {
  Algorand? algorand;
  final apiKey = 'pn6FETz0C38epEEifmWBz7kFgaxdaToZ1P12OHgX';
  Algorand initAlgorand() {
    final algodClient = AlgodClient(
      apiUrl: PureStake.TESTNET_ALGOD_API_URL,
      apiKey: apiKey,
      tokenKey: PureStake.API_TOKEN_HEADER,
    );

    final indexerClient = IndexerClient(
      apiUrl: PureStake.TESTNET_INDEXER_API_URL,
      apiKey: apiKey,
      tokenKey: PureStake.API_TOKEN_HEADER,
    );

    final kmdClient = KmdClient(
      apiUrl: '127.0.0.1',
      apiKey: apiKey,
    );

    return algorand = Algorand(
      algodClient: algodClient,
      indexerClient: indexerClient,
      kmdClient: kmdClient,
    );
  }
}
