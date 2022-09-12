import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper{

  final String apiKey = '4A395885-DD16-4212-8C97-496BEC4BA530';
  String selectedCurrency = 'USD';
  String crypto = 'BTC';

  NetworkHelper(this.selectedCurrency,this.crypto);

  Future<String> getData() async{

    Uri uri = Uri.parse('https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=$apiKey');

    http.Response response = await http.get(uri);
    if(response.statusCode == 200){
      print('connection successful');
      var decode = jsonDecode(response.body);
      var rawRate = decode["rate"];
      String rate = rawRate.toStringAsFixed(2);
      return rate;
    } else{
      print('connection unsuccessful');
      throw 'something went wrong with the request';
    }
  }
}