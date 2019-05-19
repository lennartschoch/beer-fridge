import 'dart:convert';

import 'package:beer_fridge_app/utils/app_constants.dart';
import 'package:rx_command/rx_command.dart';
import 'package:web_socket_channel/io.dart';

class WebsocketService {
  IOWebSocketChannel _socketConn;

  double get temperature => temperatureStream.lastResult;

  bool get state => stateStream.lastResult;

  RxCommand<double, double> temperatureStream;
  RxCommand<bool, bool> stateStream;

  WebsocketService() {
    temperatureStream = RxCommand.createSync((temp) => 20.0);
    stateStream = RxCommand.createSync((state) => state);

    // The default state is turned off / false
    stateStream.execute(false);

    _initWebsocketServer();
  }

  setState(bool state) async {
    Map message = {'state': state ? 'on' : 'off'};
    print(jsonEncode(message));
    _socketConn.sink.add(jsonEncode(message));
    Future.delayed(
        Duration(milliseconds: 500), () => stateStream.execute(state));
  }

  _initWebsocketServer() {
    _socketConn = IOWebSocketChannel.connect(AppConstants.SOCKET_URL,
        headers: {'X-Auth-Token': AppConstants.CLIENT_TOKEN});

    _socketConn.stream.listen(_processMessage);
  }

  _processMessage(dynamic message) {
    if (message is String) {
      Map<String, dynamic> decodedMessage = jsonDecode(message);

      if (decodedMessage.containsKey('state')) {
        _processStateMessage(decodedMessage['state']);
      }

      if (decodedMessage.containsKey('temperature')) {
        _processTemperatureMessage(decodedMessage['temperature']);
      }
    }
  }

  _processStateMessage(dynamic stateValue) {
    print('state change message received');

    if (stateValue is String) {
      if (stateValue == 'on') {
        stateStream.execute(true);
      } else if (stateValue == 'off') {
        stateStream.execute(false);
      }
    }
  }

  _processTemperatureMessage(dynamic temperatureValue) {
    if (temperatureValue is num) {
      // in case temperature is an int, cast it to double like this
      double temperatureDouble = temperatureValue + .0;

      temperatureStream.execute(temperatureDouble);
    }
  }
}
