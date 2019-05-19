import 'package:flutter/material.dart';

class Accessoire extends StatelessWidget {
  String imageResource;
  double left, top, width, height, rotationAngle;

  Accessoire(this.imageResource,
      {this.left = 0,
      this.top = 0,
      this.width,
      this.height,
      this.rotationAngle = 0});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Transform.rotate(
          angle: rotationAngle,
          child: Image.asset(imageResource, width: width, height: height)),
    );
  }
}

class Sunglasses extends Accessoire {
  Sunglasses() : super('assets/accessoires/sunglasses.png', width: 80.0, top: 70.0);
}

class StrawHat extends Accessoire {
  StrawHat() : super('assets/accessoires/straw_hat.png', width: 100.0, left: -10, top: -20);
}

class Parasol extends Accessoire {
  Parasol() : super('assets/accessoires/parasol.png', height: 300, left: -150, top: -120, rotationAngle: -0.3);
}

class BeerForBeers extends Accessoire {
  BeerForBeers() : super('assets/beer.png', height: 50, left: 75, top:  120, rotationAngle: 0.3);
}

class SwimmingTrunks extends Accessoire {
  SwimmingTrunks() : super('assets/accessoires/swimming_trunks.png', width: 90, left: -5, top: 200);
}

class SnowHat extends Accessoire {
  SnowHat() : super('assets/accessoires/snow_hat.png', width: 60.0, left: 10, top: -20);
}

class Scarf extends Accessoire {
  Scarf() : super('assets/accessoires/scarf.png', width: 120.0, left: -20, top: 100);
}

class Penguin extends Accessoire {
  Penguin() : super('assets/accessoires/penguin.png', width: 120.0, left: -120, top: 175);
}

class IceScraper extends Accessoire {
  IceScraper() : super('assets/accessoires/ice_scraper.png', height: 70, left: 65, top: 120, rotationAngle: 0.2);
}
