

import 'package:workshop/core/flavor/flavor_config.dart';
import 'package:workshop/main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.DEV,
    values: FlavorValues(
      baseUrl: "https://devurl",
    )
  );

  mainApp();
}