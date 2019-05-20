import 'package:beer_fridge_app/service_locator.dart';
import 'package:beer_fridge_app/services/websocket_service.dart';
import 'package:beer_fridge_app/utils/app_constants.dart';
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  String filename;

  _BackgroundState() {
    sl
        .get<WebsocketService>()
        .temperatureStream
        .listen((temperature) => setState(() {
          
          if(temperature >= AppConstants.SUMMER_TEMPERATURE) {
            filename = 'beach.jpg';
          } else if(temperature <= AppConstants.WINTER_TEMPERATURE) {
            filename = 'arctic.jpg';
          } else {
            filename = 'xp.jpg';
          }
          
    }));
  }

  @override
  Widget build(BuildContext context) {

    if(filename != null) {

      return Positioned.fill(
        //
        child: Image(
          image: AssetImage('assets/backgrounds/$filename'),
          fit: BoxFit.cover,
        ),
      );

    } else {

      return Container();

    }
  }
}
