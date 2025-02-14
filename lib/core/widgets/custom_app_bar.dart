import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workshop/core/config/routes.dart';
import 'package:workshop/core/theme/light_color.dart';
import 'package:workshop/core/widgets/extentions.dart';

import '../theme/theme.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon(context, Icons.sort, color: Colors.black54),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            child: Image.asset("assets/pin.png", width: 24, height: 24, color: LightColor.orange,),
          ).ripple(() {
            Get.toNamed(Routes.nearbyStorePage);
          }, borderRadius: const BorderRadius.all(Radius.circular(13)))
        ],
      ),
    );
  }

  Widget _icon(BuildContext context, IconData icon,
      {Color color = LightColor.iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {}, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }
}
