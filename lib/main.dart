import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workshop/core/config/fcm/fcm_notification.dart';
import 'package:workshop/core/config/locale/localizations_delegate.dart';
import 'package:workshop/core/config/routes.dart';
import 'package:workshop/core/di/application_controller.dart';
import 'package:workshop/core/di/auth_controller.dart';
import 'package:workshop/core/di/cart_controller.dart';
import 'package:workshop/core/di/di.dart';
import 'package:workshop/core/lifecycle/lifecycle_listener.dart';
import 'package:workshop/core/theme/title_text.dart';
import 'package:workshop/core/widgets/custom_confirm_dialog.dart';
import 'package:workshop/core/widgets/header.dart';
import 'package:workshop/src/pages/main/main_content.dart';
import 'package:workshop/src/pages/main/main_page_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'core/theme/light_color.dart';
import 'core/theme/theme.dart';

void mainApp() async {

  //DI
  await initGetX();

  //Firebase initialize
  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());

  await PushNotificationService().init();
}

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {
        'en_US': {
          'hello': 'Hello World',
        },
        'th_TH': {
          'hello': 'สวัสดี',
        }
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      locale: Get.locale,
      supportedLocales: ApplicationController.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if(supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      // locale : const Locale('en','US'), //ภาษาเริ่มต้นของ App
      // translations: LocaleString(), //เป็นไฟล์สำหรับ map ภาษาต่างๆ
      // fallbackLocale: const Locale('th','TH'), //กรณีที่ว่าเราสลับภาษาอยู่และหาไฟล์ไม่เจอ จะใช้ภาษาอะไรเป็นภาษาเริ่มต้น

      // unknownRoute: GetPage('notfound', page: () => UnknownPage()), //ของเว็บ
      getPages: Routes.getPageRoute(),
      // routes: Routes.getRoute(),
      initialRoute: Routes.rootPage,
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

class MyHomePage extends StatelessWidget with LifecycleListenerEvent {
  // MyHomePage({Key? key}) : super(key: key);

  final _mainPageController = Get.put(MainPageController());
  late LifecycleListener _lifecycleListener;

  MyHomePage({Key? key}) : super(key: key) {
    _lifecycleListener = LifecycleListener(providerInstance: this);
  }

  @override
  void onResume() {
    print("onResume MyHomePage");
  }

  //หาขนาดหน้าจอ
  // double bottom = MediaQuery.paddingOf(context).bottom;
  // final safePadding = MediaQuery.paddingOf(context).top; // Will cause a rebuild only if padding changes (requires Flutter > 3.10)
  // double? hight = MediaQuery.of(context).size.height;
  // print('Fullwidth ${hight}');
  // print('status ${safePadding}');
  // print('bottom ${bottom}');
  // print('sum ${hight - safePadding - bottom} ');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
            context: context,
            builder: (ctx) {
              return CustomConfirmDialog(
                title: "ยืนยันปิดแอปพลิเคชัน??",
                description: "",
                positiveText: "ยืนยัน",
                negativeText: "ยกเลิก",
                positiveColor: LightColor.orange,
                assetImage: "assets/logout.svg",
                positiveHandler: () async {
                  Get.find<AuthController>().endSession();

                  //  Get.offAllNamed(Routes.rootPage); //ออกมาหน้าแรก

                  //_exitApp();
                },


                negativeHandler: () async {

                },
              );
            });

        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Header(headLine1: 'Our', headLine2: 'Product'),
              Expanded(child: MainContent()),
            ],
          ),
        ),
        floatingActionButton: _floatingButton(),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: AppTheme.padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our",
            style: GoogleFonts.mulish().copyWith(
              fontSize: 27,
              fontWeight: FontWeight.w400,
              color: LightColor.titleTextColor,
            ),
            // TextStyle(
            //   fontSize: 27,
            //   fontWeight: FontWeight.w400,
            //   color: LightColor.titleTextColor,
            // ),
          ),
          Text(
            "Product",
            style: GoogleFonts.mulish().copyWith(
              fontSize: 27,
              fontWeight: FontWeight.w700,
              color: LightColor.titleTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingButton(/*BuildContext context*/) {
    return FloatingActionButton(
      onPressed: () {
        // Navigator.of(context).pushNamed(Routes.shoppingCartPage);
        Get.toNamed(Routes.shoppingCartPage);
        //   _mainPageController.increment();
        //   _mainPageController.increment2();
      },
      backgroundColor: LightColor.orange,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Icon(Icons.shopping_basket,
                    color: Theme.of(Get.context!)
                        .floatingActionButtonTheme
                        .backgroundColor),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 22,
                  height: 22,
                  padding: const EdgeInsets.only(left: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: LightColor.orange),
                    color: Colors.white,
                  ),
                  child: GetBuilder<CartController>(
                    builder: (controller) {
                      return TitleText(
                        text: "${controller.cartTotal}",
                        color: LightColor.orange,
                        fontSize: 12,
                      );
                    },
                  ),

                  // Obx(
                  //     () => TitleText(
                  //       text: "${_mainPageController.counter2}",
                  //       color: LightColor.orange,
                  //       fontSize: 12,
                  //     )
                  // ),

                  // GetX<MainPageController>(
                  //   init: _mainPageController,
                  //   builder: (MainPageController controller) {
                  //     return TitleText(
                  //       text: "${_mainPageController.counter2}",
                  //       color: LightColor.orange,
                  //       fontSize: 12,
                  //     );
                  //   },
                  // ),

                  // GetBuilder<MainPageController>(
                  //   init: _mainPageController,
                  //   builder: (MainPageController controller) {
                  //     return TitleText(
                  //       text: "${_mainPageController.counter}",
                  //       color: LightColor.orange,
                  //       fontSize: 12,
                  //     );
                  //   },
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exitApp () {
    if(Platform.isIOS){
      try{
        exit(0);
      }catch (e){
        SystemNavigator.pop();
      }
    } else {
      try {
        SystemNavigator.pop();
      } catch (e) {
        exit(0);
      }
    }
  }

}
