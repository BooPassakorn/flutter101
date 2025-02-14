import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workshop/core/theme/title_text.dart';

class CustomConfirmDialog extends StatelessWidget {
  const CustomConfirmDialog(
      {Key? key,
      required this.title,
      required this.description,
      required this.positiveText,
      required this.negativeText,
      required this.assetImage,
      this.positiveHandler,
      this.negativeHandler,
      required this.positiveColor})
      : super(key: key);

  final String title;
  final String description;
  final String positiveText;
  final String negativeText;
  final Color positiveColor;
  final String assetImage;
  final VoidCallback? positiveHandler;
  final VoidCallback? negativeHandler;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0, //แสงเงา
      backgroundColor: Colors.transparent,
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // boxShadow: const [
        //   BoxShadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 5),
        // ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 27,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(
                          assetImage,
                          height: 50,
                          width: 50,
                        ),
                        // Image.asset(
                        //   assetImage,
                        //   height: 50,
                        //   width: 50,
                        // ),
                        const SizedBox(
                          height: 14,
                        ),
                      ],
                    ),
                    TitleText(text: title),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 48,
          ),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15)),
                          color: Colors.grey.shade200,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                              )
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              if (negativeHandler!= null) {
                                negativeHandler!();
                              }
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: TitleText(
                                  text: negativeText,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ),
                Expanded(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                            const BorderRadius.only(bottomRight: Radius.circular(15)),
                          color: positiveColor,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                              )
                            ),
                            onTap: (){
                              Navigator.pop(context);
                              if (positiveHandler != null) {
                                positiveHandler!();
                              }
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: TitleText(
                                  text: positiveText,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
