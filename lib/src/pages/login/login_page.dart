import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workshop/core/config/locale/languages/languages.dart';
import 'package:workshop/core/di/application_controller.dart';
import 'package:workshop/core/di/auth_controller.dart';
import 'package:workshop/core/flavor/flavor_config.dart';
import 'package:workshop/core/theme/light_color.dart';
import 'package:workshop/core/theme/title_text.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _authController = Get.find<AuthController>();

  late Languages language;

  @override
  Widget build(BuildContext context) {
    language = Languages.of(context)!;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("hello".tr),
            Text(language.loading),
            Image.asset("assets/logo.png"),
            _loginWithKeycloak(),
            _bypassLoginButton(),
            _updateLocaleTH(),
            _updateLocaleEN(),
            Text(FlavorConfig.instance.name),
            Text("${Get.locale}")
          ],
        ),
      ),
    );
  }

  Widget _loginWithKeycloak() {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          _authController.signInWithAutoCodeExchange();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, //primary
          foregroundColor: LightColor.orange, //onPrimary
          shape: const StadiumBorder(),
          side: const BorderSide(color: LightColor.orange),
        ),
        child: const TitleText(
          text: "Login with Keycloak",
          fontWeight: FontWeight.w400,
          color: LightColor.orange,
        ),
      ),
    );
  }

  Widget _bypassLoginButton() {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          _authController.bypassLogin();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(LightColor.orange),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: LightColor.orange))),
        ),

        // ElevatedButton.styleFrom(
        //   backgroundColor: Colors.orange, //primary
        //   foregroundColor: Colors.white, //onPrimary
        //   shape: const StadiumBorder(),
        //   side: const BorderSide(color: LightColor.orange),
        // ),
        child: TitleText(
          text: "Bypass login",
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _updateLocaleTH() {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          var locale = Locale('hi', 'IN');
          // Get.updateLocale(locale);
          Get.find<ApplicationController>().changeLanguage('th');
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(LightColor.orange),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: LightColor.orange))),
        ),
        child: TitleText(
          text: "Update Locale TH",
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _updateLocaleEN() {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          var locale = Locale('hi', 'IN');
          // Get.updateLocale(locale);
          Get.find<ApplicationController>().changeLanguage('en');
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(LightColor.orange),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: const BorderSide(color: LightColor.orange))),
        ),
        child: TitleText(
          text: "Update Locale EN",
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
}
