

import 'package:workshop/core/flavor/flavor_config.dart';
import 'package:workshop/main.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.PRODUCTION,
      values: FlavorValues(
        baseUrl: "https://productionurl",
      )
  );

  mainApp();
}