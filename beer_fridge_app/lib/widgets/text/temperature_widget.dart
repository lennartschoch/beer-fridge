import 'package:beer_fridge_app/service_locator.dart';
import 'package:beer_fridge_app/services/websocket_service.dart';
import 'package:flutter/material.dart';

class TemperatureWidget extends StatefulWidget {
  @override
  _TemperatureWidgetState createState() => _TemperatureWidgetState();
}

class _TemperatureWidgetState extends State<TemperatureWidget> {
  double _temperature;
  bool _state;

  _TemperatureWidgetState() {
    _temperature = sl.get<WebsocketService>().temperature;

    sl
        .get<WebsocketService>()
        .temperatureStream
        .listen((temp) => setState(() => _temperature = temp));

    _state = sl.get<WebsocketService>().state;

    sl
        .get<WebsocketService>()
        .stateStream
        .listen((state) => setState(() => _state = state));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.black),
      child: Text(
        _temperature == null ? '-' : _temperature.toString() + '°C',
        style: TextStyle(
            fontFamily: 'Open 24 Display ST',
            color: _state ? Colors.green : Colors.red,
            fontSize: 48.0,
            height: 0.85),
      ),
    );
  }
}
