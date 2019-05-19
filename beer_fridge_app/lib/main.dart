import 'package:beer_fridge_app/service_locator.dart';
import 'package:beer_fridge_app/views/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {

  setUpServiceLocator(rootBundle);
  runApp(BeerFridgeApp());

}

class BeerFridgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beer Fridge App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.purple
      ),
      home: DashboardView()
    );
  }
}
