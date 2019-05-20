import 'package:beer_fridge_app/widgets/background.dart';
import 'package:beer_fridge_app/widgets/beer/beer.dart';
import 'package:beer_fridge_app/widgets/buttons/fridge_state_button.dart';
import 'package:beer_fridge_app/widgets/text/temperature_widget.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(children: [
        Background(),
        Positioned(
          top: 48.0,
          left: 0,
          right: 0,
          child:
              Row(
                  children: [TemperatureWidget()],
                mainAxisAlignment: MainAxisAlignment.center,
              )
        ),
        Positioned(
            bottom: 48.0,
            left: 0,
            right: 0,
            child:
            Row(
              children: [FridgeStateButton()],
              mainAxisAlignment: MainAxisAlignment.center,
            )
        ),
        Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Beer()],
        ))
      ]),
    );
  }
}
