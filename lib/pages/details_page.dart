import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget{

  final Map rates;

  const DetailsPage({super.key, 
    required this.rates
  }); 

  @override
  Widget build(BuildContext context) {
    List currencies = rates.keys.toList();
    List exchangeRates = rates.values.toList();
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: currencies.length,
          itemBuilder: (BuildContext context, int index) {
            String curr = currencies[index].toString().toUpperCase();
            String exRate = exchangeRates[index].toString();
            return ListTile(
              title: Text(
                "$curr: $exRate", 
                style: const TextStyle(
                  color: Colors.white),
                  ),
            );
            },
        )
        ),
    );
  }

}