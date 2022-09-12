import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'networking.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

String selectedCurrency = 'USD';
String crypto = 'BTC';

class _PriceScreenState extends State<PriceScreen>{

  int _selectedItem = 0;
  var rate  = '?';


  @override
  void initState() {
    super.initState();
    getRates();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $crypto = $rate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            margin: EdgeInsets.fromLTRB(18.0, 18.0, 18.0,18.0),
            child: TextField(
              autofillHints: cryptoList,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Crypto Currency',
                fillColor: Colors.lightBlueAccent,
                filled: true,
              ),
             onChanged: (input){
                setState((){
                  print('input field triggered');
                  crypto = input;
                  getRates();
                  print(crypto);
                });
             },
            ),
          ),
        ],
      ),
      bottomSheet: Container(
          height: 150.0,
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 30.0),
          color: Colors.lightBlue,
          child: Platform.isIOS?iosCupertinoPicker():androidDropdown()),
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItem = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItem.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItem,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value.toString();
            print(value);
            getRates();
            print(rate);
          });
        });
  }

  CupertinoPicker iosCupertinoPicker() {
    List<Text> pickerItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      children: pickerItems,
      onSelectedItemChanged: (selectedItemIndex) {
        _selectedItem = selectedItemIndex;
        print(currenciesList[_selectedItem]);
      },
      itemExtent: 32,
    );
  }

  void getRates() async{
    NetworkHelper net = NetworkHelper(selectedCurrency,crypto);
    String data = await net.getData();
    setState(() {
      print(data);
      rate = data;
    });
  }
}

