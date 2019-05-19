import 'package:beer_fridge_app/service_locator.dart';
import 'package:beer_fridge_app/services/websocket_service.dart';
import 'package:flutter/material.dart';

class FridgeStateButton extends StatefulWidget {
  @override
  _FridgeStateButtonState createState() => _FridgeStateButtonState();


}

class _FridgeStateButtonState extends State<FridgeStateButton> {

  bool _state;

  _FridgeStateButtonState() {
    _state = sl
        .get<WebsocketService>()
        .state;

    sl
        .get<WebsocketService>()
        .stateStream
        .listen((state) => setState(() => this._state = state));
  }

  @override
  Widget build(BuildContext context) {

    String filename = 'assets/switch_${_state ? 'on' : 'off'}.png';
    
    return GestureDetector(
      onTap: () => sl.get<WebsocketService>().setState(!_state),
      child: Image.asset(filename, width: 120),
    );
  }

}