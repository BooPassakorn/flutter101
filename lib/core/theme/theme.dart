import 'package:flutter/material.dart';

import 'light_color.dart';

class AppTheme {
  const AppTheme();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: LightColor.background,
    backgroundColor: LightColor.background,
    primaryColor: LightColor.background,
    cardTheme: const CardTheme(color: LightColor.background),
    textTheme: const TextTheme(bodyText1: TextStyle(color: LightColor.black)),
    iconTheme: const IconThemeData(color: LightColor.iconColor),
    bottomAppBarColor: LightColor.background,
    dividerColor: LightColor.lightGrey,
    primaryTextTheme:
    const TextTheme(bodyText1: TextStyle(color: LightColor.titleTextColor)),
  );

  static TextStyle titleStyle =
  const TextStyle(color: LightColor.titleTextColor, fontSize: 16);
  static TextStyle subTitleStyle =
  const TextStyle(color: LightColor.subTitleTextColor, fontSize: 12);

  static TextStyle h1Style =
  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle h2Style = const TextStyle(fontSize: 22);
  static TextStyle h3Style = const TextStyle(fontSize: 20);
  static TextStyle h4Style = const TextStyle(fontSize: 18);
  static TextStyle h5Style = const TextStyle(fontSize: 16);
  static TextStyle h6Style = const TextStyle(fontSize: 14);

  static List<BoxShadow> shadow = <BoxShadow>[
    const BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding =
  const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  static double fullWidth(BuildContext context) {
    // double? width = MediaQuery.of(context).size.width;
    //     // print('say ${width}');
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context){
  //  final safePadding = MediaQuery.paddingOf(context).top; // Will cause a rebuild only if padding changes (requires Flutter > 3.10)
  //  final navi = MediaQuery.paddingOf(context).bottom;
  //  // final safePadding = MediaQuery.of(context).padding.top;
  // //   final safePadding = WidgetsBinding.instance.window.padding.top;
  //
  //   final safepadding = WidgetsBinding.instance.platformDispatcher.implicitView!.padding.top;
  //
  //   double? hight = MediaQuery.of(context).size.height;
  //   var heightstatus = MediaQuery.of(context).padding.top;
  //   print('status ${heightstatus}');
  //   print('navi ${navi}');
  //   print('sayH ${hight}');
  //   print('saysafe ${safePadding}');
  //   print('saysafepadding ${safepadding}');
  //
  //   print('full Screen height: ${MediaQuery.of(context).size.height}');
  //   print('Screen height: ${MediaQuery.of(context).size.height}');
    // print('Real safe height: ${constraints.maxHeight}');
    return MediaQuery.of(context).size.height;
  }
}
