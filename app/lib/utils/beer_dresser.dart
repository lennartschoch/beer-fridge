import 'package:beer_fridge_app/service_locator.dart';
import 'package:beer_fridge_app/services/websocket_service.dart';
import 'package:beer_fridge_app/utils/app_constants.dart';
import 'package:beer_fridge_app/widgets/beer/accessoires.dart';
import 'package:meta/meta.dart';

class BeerDresser {
  BeerDresser({@required Function(List<Accessoire>) onBeerOutfitChanges}) {
    sl.get<WebsocketService>().temperatureStream.listen((temperature) {
      onBeerOutfitChanges(_getAccessoiresByTemperature(temperature));
    });
  }

  List<Accessoire> _getAccessoiresByTemperature(double temperature) {
    if (temperature <= AppConstants.WINTER_TEMPERATURE) {
      return [
        SnowHat(),
        Scarf(),
        Penguin(),
        IceScraper()
      ];
    } else if (temperature >= AppConstants.SUMMER_TEMPERATURE) {
      return [
        Parasol(),
        Sunglasses(),
        StrawHat(),
        BeerForBeers(),
        SwimmingTrunks()
      ];
    }

    return [];
  }
}
