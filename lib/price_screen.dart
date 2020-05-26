import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';
import 'coin_data.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList.first;
  bool isWaiting = false;
  Map<String, double> values = {};

  Widget getMaterialDropdown() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currenciesList
          .map<DropdownMenuItem<String>>(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: (newValue) {
        setState(() {
          selectedCurrency = newValue;
          updateUI();
        });
      },
    );
  }

  Widget getCupertinoPicker() {
    return CupertinoPicker(
      itemExtent: 25.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          updateUI();
        });
      },
      children: currenciesList.map((e) => Text(e)).toList(),
    );
  }

  Future<double> getExchangeRate({String base}) async {
    var data =
        await CoinData().getCoinData(base: base, quote: selectedCurrency);
    if (data != null) {
      return data['rate'];
    }
  }

  void updateUI() async {
    setState(() {
      isWaiting = true;
    });

    for (String base in cryptoList) {
      double exchangeRate = await getExchangeRate(base: base);
      values[base] = exchangeRate;
    }

    setState(() {
      isWaiting = false;
    });
  }

  @override
  void initState() {
    super.initState();

    updateUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoList
                .map(
                  (e) => CoinCard(
                    base: e,
                    quote: selectedCurrency,
                    rate: isWaiting ? '?' : values[e].toStringAsFixed(2),
                  ),
                )
                .toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                Platform.isIOS ? getCupertinoPicker() : getMaterialDropdown(),
          ),
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  final String base, quote, rate;

  CoinCard({this.base, this.quote, this.rate});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '1 $base = $rate $quote',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
