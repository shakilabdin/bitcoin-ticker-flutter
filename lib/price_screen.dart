import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'exchange_card.dart';
import 'exchange_rate.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    updateRates();
  }

  String selectedCurrency = 'AUD';
  double btcRate = 0;
  double ethRate = 0;
  double ltcRate = 0;

  void updateRates() async {
    ExchangeRate exchangeRate = ExchangeRate();
    setState(() async {
      btcRate = await exchangeRate.getRate('BTC', selectedCurrency);
      ethRate = await exchangeRate.getRate('ETH', selectedCurrency);
      ltcRate = await exchangeRate.getRate('LTC', selectedCurrency);
    });
  }

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem> currencyDropdown = [];

    for (int i = 0; i < currenciesList.length; i++) {
      currencyDropdown.add(DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      ));
    }

    return DropdownButton(
      value: selectedCurrency,
      items: currencyDropdown,
      onChanged: (value) {
        updateRates();
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(
        currency,
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        updateRates();
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: pickerItems,
      backgroundColor: Colors.lightBlue,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else {
      return getDropdownButton();
    }
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
            children: [
              ExchangeCard(
                  crypto: 'BTC',
                  selectedCurrency: selectedCurrency,
                  price: btcRate.toString()),
              ExchangeCard(
                  crypto: 'ETH',
                  selectedCurrency: selectedCurrency,
                  price: ethRate.toString()),
              ExchangeCard(
                  crypto: 'LTC',
                  selectedCurrency: selectedCurrency,
                  price: ltcRate.toString()),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
