import 'dart:convert';
import 'package:coincap/pages/details_page.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double? _deviceHeight, _deviceWidth;
  HTTPService? _http;
  String? _selectedCoin = "bitcoin";

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropDown(),
              _dataWidget(),
            ]),
      ),
    ));
  }

  Widget _selectedCoinDropDown() {
    List<String> coins = ["bitcoin", "ethereum", "tether", "cardano", "ripple"];

    List<DropdownMenuItem<String>> items = coins
        .map((c) => DropdownMenuItem(
              value: c,
              child: Text(
                c,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
            ))
        .toList();
    return DropdownButton(
      value: _selectedCoin,
      items: items,
      onChanged: (value) {
        setState(() {
          _selectedCoin = value;
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidget() {
    return FutureBuilder(
        future: _http!.get("/coins/$_selectedCoin"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map data = jsonDecode(snapshot.data.toString());
            num usdPrice = data["market_data"]["current_price"]["usd"];
            num change24h = data["market_data"]["price_change_percentage_24h"];
            Map exchangeRate = data["market_data"]["current_price"];
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: _coinImageWidget(data["image"]["large"]),
                  onDoubleTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DetailsPage(rates: exchangeRate,);
                    }));
                  },
                ),
                _currentPriceWidget(usdPrice),
                _percentageChangeWidget(change24h),
                _descriptionWidget(data["description"]["en"]),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
        });
  }

  Widget _currentPriceWidget(num rate) {
    return Text(
      "${rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
    );
  }

  Widget _percentageChangeWidget(num change) {
    return Text(
      "${change.toString()} %",
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
    );
  }

  Widget _coinImageWidget(String url) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.02,
      ),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(url)),
      ),
    );
  }

  Widget _descriptionWidget(String description) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.05,
      ),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceHeight! * 0.01,
      ),
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        description,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
