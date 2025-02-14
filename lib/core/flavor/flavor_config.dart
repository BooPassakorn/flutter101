import 'package:workshop/core/flavor/string_utils.dart';

enum Flavor { DEV, PRODUCTION }

class FlavorValues {
  FlavorValues({
    required this.baseUrl,
  });

  final String baseUrl;
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;

  static late FlavorConfig _instance;

  static FlavorConfig get instance {
    return _instance;
  }

  factory FlavorConfig({required Flavor flavor, required FlavorValues values}) {
    _instance = FlavorConfig._internal(
        flavor, StringUtils.enumName(flavor.toString()), values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.values);

  
}
