import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workshop/core/config/routes.dart';
import 'package:workshop/core/theme/light_color.dart';
import 'package:workshop/core/theme/theme.dart';
import 'package:workshop/core/widgets/category_item.dart';
import 'package:workshop/core/widgets/extentions.dart';
import 'package:workshop/src/model/data.dart';
import 'package:workshop/src/pages/detail/product_detail_page.dart';
import 'package:workshop/src/pages/detail/product_item.dart';
import 'package:workshop/src/pages/main/main_page_controller.dart';

import '../search_by_image/search_by_image_page.dart';

class MainContent extends StatelessWidget {
  MainContent({Key? key}) : super(key: key);

  final _mainPageController = Get.find<MainPageController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        reverse: false,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _search(context),
            _categoryWidgetListView(context),
            //_categoryWidgetListViewBuilder(context),
            SizedBox(
              height: 16,
            ),
            // _productWidgetFixedColumn(context),
            // _productWidgetMaxCrossAxisExtent(context),
            _productList(context),
          ],
        ),
      ),
    );
  }

  Widget _search(BuildContext context) {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: [
          // Expanded(child: _textFieldTest()),
          Expanded(child: _textField()),
          const SizedBox(
            width: 20,
          ),
          _iconFilter(context, Icons.filter_list, color: Colors.black54),
          const SizedBox(
            width: 20,
          ),
          _iconSearchByImage(context, Icons.image, color: Colors.black54),
        ],
      ),
    );
  }

  // Widget _textFieldTest(){
  Widget _textField() {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: LightColor.lightGrey.withAlpha(100),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: TextField(
        controller: _mainPageController.searchController,
        onSubmitted: (_){
          _mainPageController.search();
        },
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Search Products",
            hintStyle: TextStyle(fontSize: 12),
            contentPadding:
                EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
            prefixIcon: Icon(Icons.search, color: Colors.black54)),
      ),
    );
  }

  Widget _iconFilter(BuildContext context, IconData icon,
      {Color color = LightColor.iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color: Theme.of(context).backgroundColor,
        boxShadow: AppTheme.shadow,
      ),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {
      _mainPageController.getData();
    }, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }

  Widget _iconSearchByImage(BuildContext context, IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color: Theme.of(context).backgroundColor,
        boxShadow: AppTheme.shadow,
      ),
      child: Icon(
        icon,
        color: color,
      ),
    ).ripple(() {
      Get.to(() => SearchByImagePage());
    }, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }


  Widget _categoryWidgetListView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: AppTheme.fullHeight(context),
      // height: 200,
      height: 80,
      child: GetBuilder<MainPageController>(
        builder: (MainPageController controller){
          return ListView(
            scrollDirection: Axis.horizontal,
            reverse: false,
            children: controller.categoryList
                .map(
                  (category) =>
                  CategoryItem(category: category, onSelected: _onSelected),
            )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _categoryWidgetListViewBuilder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: 150,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        reverse: false,
        itemCount: Appdata.categorylist.length,
        itemBuilder: (ctx, index) {
          final category = Appdata.categorylist[index];
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Container(
                padding: AppTheme.hPadding,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: category.isSelected
                      ? LightColor.background
                      : Colors.transparent,
                  border: Border.all(
                    color: category.isSelected
                        ? LightColor.orange
                        : LightColor.grey,
                    width: category.isSelected ? 2 : 1,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: category.isSelected
                          ? const Color(0xfffbf2ef)
                          : Colors.white,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      category.image,
                      height: 40,
                    ),
                    Text(category.name,
                        style: GoogleFonts.mulish(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: LightColor.titleTextColor)),
                  ],
                ),
              ).ripple(
                () {
                  // onSelected(model)
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ));
        },
      ),
    );
  }

  Widget _productWidgetFixedColumn(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context) * .7,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4 / 3,
            mainAxisSpacing: 30,
            crossAxisSpacing: 20),
        padding: const EdgeInsets.only(left: 20, right: 20),
        scrollDirection: Axis.vertical,
        reverse: false,
        children: Appdata.productList
            .map(
              (product) => Container(
                color: Colors.amber,
                child: Center(child: Text(product.id.toString())),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _productWidgetMaxCrossAxisExtent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context) * .7,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 4 / 3,
            mainAxisSpacing: 30,
            crossAxisSpacing: 20),
        padding: const EdgeInsets.only(left: 20, right: 20),
        scrollDirection: Axis.vertical,
        reverse: false,
        children: Appdata.productList
            .map(
              (product) => Container(
                color: Colors.blue,
                child: Center(child: Text(product.id.toString())),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _productList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context) * 0.7,
      child: GetBuilder<MainPageController>(
        builder: (controller){
          if(controller.productList.isNotEmpty){
            return GridView(
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 4 / 3,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 20),
              padding: const EdgeInsets.only(left: 20, right: 20),
              scrollDirection: Axis.horizontal,
              children: controller.productList
                  .where((element) =>
              controller.getSelectedCategory()?.name == element.category)
                  .map(
                    (product) => ProductItem(
                  product: product,
                  onSelected: _onSelectedProduct,
                ),
              )
                  .toList(),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _onSelected(dynamic category) {
    _mainPageController.updateCategorySelected(category);
  }

  void _onSelectedProduct(item) {
    // Navigator.of(context).pushNamed(
    //     Routes.detailPage,
    //     arguments: {
    //       ProductDetailPage.productItemArg: item,
    // });

    // Navigator.of(context).pushNamed(
    //   Routes.detailPage,
    //   arguments: {
    //     ProductDetailPage.productItemArg: item,
    //     ProductDetailPage.productItemArg: item,
    //   },
    // ); //routing ที่ระบุด้วยชื่อที่ตั้งไว้

    Get.toNamed( //ขาส่ง
      Routes.detailPage,
      arguments: [
        {
          ProductDetailPage.productItemArg: item,
        },
        // {
        //   ProductDetailPage.productItemArg: item,
        // },
      ],
    );

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ProductDetailPage()),
    // ); //ระบุ widget
  }
}
