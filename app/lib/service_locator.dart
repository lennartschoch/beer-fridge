import 'package:beer_fridge_app/services/websocket_service.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

GetIt sl = new GetIt();

setUpServiceLocator(AssetBundle bundle) =>
    sl.registerLazySingleton<WebsocketService>(() => WebsocketService());
