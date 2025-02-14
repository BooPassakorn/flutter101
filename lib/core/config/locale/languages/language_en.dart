import 'package:workshop/core/config/locale/languages/languages.dart';

class LanguageEn extends Languages {
  @override
  String get bypassLogin => "bypass login";

  @override
  String get connectionException => "Connection Exception";

  @override
  String get connectionTimeout => "Connection timeout";

  @override
  String get errorOccurred => "error occurred";

  @override
  String get loading => "Loading";

  @override
  String get loginWithKeycloak => "Login with Keycloak";

  @override
  String get notFound404 => "URL not found";

  @override
  String get pleaseConnectToTheInternet => "Please connect to the internet";

  @override
  String get pleaseContactAdmin => "Please contact administrator";

  @override
  String get setting => "Setting";

  @override
  String get logout => "Logout";

}