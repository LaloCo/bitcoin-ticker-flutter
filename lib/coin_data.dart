import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinApiExchangeRateEndpoint = 'https://rest.coinapi.io/v1/exchangerate';
const coinApiKey = '339A7763-49A0-402F-A903-9424DA1686FD';

class CoinData {
  Future<dynamic> getCoinData({String base, String quote}) async {
    var url = '$coinApiExchangeRateEndpoint/$base/$quote?apikey=$coinApiKey';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return;
    }
  }
}
