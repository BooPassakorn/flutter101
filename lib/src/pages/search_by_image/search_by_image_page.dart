import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:workshop/core/theme/theme.dart';
import 'package:workshop/core/theme/title_text.dart';
import 'package:workshop/src/pages/search_by_image/search_by_image_page_controller.dart';

class SearchByImagePage extends StatelessWidget {
  SearchByImagePage({Key? key}) : super(key: key);

  final _searchByImageController = Get.put(SearchByImagePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              _appBar(),
              GetBuilder<SearchByImagePageController>(
                builder: (SearchByImagePageController controller) {
                  return GestureDetector(
                    onTap: () {
                      _showOption(context);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      margin: const EdgeInsets.all(16),
                      width: 500,
                      height: 500,
                      child: controller.image != null
                          ? ClipRRect( //เอารูปมาแสดง
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(13)),
                              child: Image.file(
                                controller.image!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TitleText(
                                    color: Colors.white,
                                    text: "No Image selected",
                                  ),
                                  TitleText(
                                    color: Colors.white,
                                    text: "Tap to start",
                                  ),
                                  SizedBox(height: 4),
                                  Icon(
                                    Icons.touch_app_outlined,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          const TitleText(
            text: "Image search",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          Lottie.asset('assets/CameraAnimation.json',
              width: 100,
              height: 100,
              repeat: true,
          ),
          // const SizedBox(width: 40),
        ],
      ),
    );
  }


  Future _showOption(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _searchByImageController.getImageFromGallery();
                  Navigator.pop(Get.overlayContext!);
                },
                leading: const Icon(Icons.image_outlined),
                title: const TitleText(
                  text: "Gallery",
                  fontWeight: FontWeight.w400,
                ),
              ),
              ListTile(
                onTap: () {
                  _searchByImageController.getImageFromCamera();
                  Navigator.pop(Get.overlayContext!);
                },
                leading: const Icon(Icons.photo_camera_outlined),
                title: const TitleText(
                  text: "Camera",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        }
    );
  }

}
