import 'networking.dart';

const apiKey = 'API KEY HERE';
const cryptoUrl = 'https://rest.coinapi.io/v1/exchangerate';

class ExchangeRate {
  Future<dynamic> getRate(String crypto, String currency) async {
    NetworkHelper networkHelper =
        NetworkHelper('$cryptoUrl/$crypto/$currency?apikey=$apiKey');
    var data = await networkHelper.getData();
    print(data);
    return data['rate'];
  }
}
