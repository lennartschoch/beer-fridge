import 'package:beer_fridge_app/utils/beer_dresser.dart';
import 'package:beer_fridge_app/widgets/beer/accessoires.dart';
import 'package:flutter/material.dart';

class Beer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BeerState();
}

class _BeerState extends State<Beer> {

  double width = 80.0;
  BeerDresser beerDresser;

  List<Accessoire> accessoires = [];

  _BeerState() {
    beerDresser = BeerDresser(
        onBeerOutfitChanges: (accessoires) =>
            setState(() => this.accessoires = accessoires));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[Image.asset('assets/beer.png', width: width)]
        ..addAll(accessoires),
    );
  }
}
