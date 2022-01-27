import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/best_product_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/categories_response.dart';
import 'package:marketplace_service_provider/src/network/add%20product/app_network.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';

import 'order_cart.dart';

class ExpansionTileWidget extends StatefulWidget {
  final storeID;
  final index;
  const ExpansionTileWidget({Key key, this.index, this.storeID}) : super(key: key);

  @override
  _ExpansionTileWidgetState createState() => _ExpansionTileWidgetState();
}

class _ExpansionTileWidgetState extends State<ExpansionTileWidget> {
  String variantPrice, variantWeight, variantUnittype;
  List<SubCategory> _categoryList = [];
  bool loading = false;
  int selected;
  double price = 0;
  String selectedCategoryId = "";
  String selectedSubCategoryId = "";
  bool showLoading = true;
  bool showList = false;
  List<Data> categoryProduct = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
      child: Container(
        width: double.infinity,
        color: Colors.grey[100],
        child: ExpansionTile(
          collapsedTextColor: AppTheme.black,
          textColor: AppTheme.black,
          trailing: Text(" "),
          // key: Key(index.toString()),
          // tilePadding: EdgeInsets.all(8.0),
          initiallyExpanded: widget.index == selected,
          maintainState: false,
          onExpansionChanged: (newState) {
            setState(() {
              if (newState) {
                // this.isExpanded = newState;
                selected = widget.index;
              } else {
                // this.isExpanded = false;
                selected = -1;
              }
              selectedCategoryId =
                  _categoryList[widget.index].categoryId;
              selectedSubCategoryId =
                  _categoryList[widget.index].id;
              // if(ExpandableCategories.getProductDataMap().containsKey(int.parse(selectedSubCategoryId))) {
              //   print("category existing product");
              //   print(ExpandableCategories.getProductDataMap());
              //   categoryProduct =
              //   ExpandableCategories.getProductDataMap()[int.parse(selectedSubCategoryId)];
              //   // print(jsonEncode(categoryProduct));
              // }else{
              _getProducts();

              // }
            });
          },
          title: Row(
            children: [
              Icon(
                selected == widget.index
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: AppTheme.black,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                _categoryList[widget.index].title,
              ),
            ],
          ),
          // textColor: AppColor.textDarkColor,
          children: [
            _categoryProduct(),
          ],
        ),
      ),
    );
  }

  void _getProducts() async {
    Map<String, dynamic> param = {
      "page": 1,
      "pagelength": 1000,
      "cat_id": selectedCategoryId,
      "sub_cat_ids": selectedSubCategoryId,
    };

    AppNetwork.getCategoryProducts(param, storeID: widget.storeID).then(
            (value) => _handleProductResponse(value),
        onError: (error) => _handleError(error));
  }

  _handleProductResponse(BestProduct value) {
    loading = false;
    categoryProduct.clear();
    if (value.success) {
      List<Data> newList = [];
      value.data.forEach((data) {
        newList.add(data);
      });
      List<Data> selectedProductList = [];
      if (!OderCart.isCartEmpty()) {
        selectedProductList.addAll(OderCart.getOrderCartMap().values.toList());
      }
      List<Data> data = newList;
      for (Data getProductData in data) {
        for (Data selectedData in selectedProductList) {
          if (selectedData.id == getProductData.id) {
            getProductData.count = selectedData.count;
            getProductData.selectedVariantIndex =
                selectedData.selectedVariantIndex;
            break;
          }
        }
      }
      if (mounted) {
        setState(() {
          categoryProduct = data;
          // ExpandableCategories.putProductData(int.parse(selectedSubCategoryId), data);
          // print("data----------");
          //  print(ExpandableCategories.getProductDataMap());
          // categoryProduct =
          // ExpandableCategories.getProductDataMap()[int.parse(selectedSubCategoryId)];
          //  print(ExpandableCategories.getProductDataMap()[int.parse(selectedSubCategoryId)]);
        });
      }
    } else {
      setState(() {
        showLoading = false;
        showList = false;
        selected = -1;
      });
      AppUtils.showToast("Data not found", false);
      // EasyLoading.showToast('Data not found',
      //     toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  void _handleError(error) {
    // EasyLoading.dismiss();
    if (error is CustomException) {
      AppUtils.showToast(error.toString(), false);
      // EasyLoading.showToast(error.toString(),
      //     toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  Widget _categoryProduct() {
    return categoryProduct.length > 0
        ? Container(
      color: AppTheme.chipsBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 6 / 9,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8),
            itemCount: categoryProduct.length,
            itemBuilder: (BuildContext context, int index) {
              return index < categoryProduct.length
                  ? InkWell(
                onTap: () {
                  setState(() {
                    categoryProduct[index].count += 1;
                    OderCart.putOrder(categoryProduct[index]);
                    price = double.parse(categoryProduct[index]
                        .variants[categoryProduct[index]
                        .selectedVariantIndex]
                        .price);
                    // total!=null? total+=price: total=price;
                    // calculateAmount();
                  });
                },
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        left: 90,
                        right: 0,
                        child: Column(
                          children: [
                            Container(
                              color: AppTheme.black,
                              height: 20,
                              width: 20,
                              child: Center(
                                  child: Text(
                                    "+",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16),
                                  )),
                            ),
                            Visibility(
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Center(
                                    child: Text(
                                      categoryProduct[index]
                                          .count
                                          .toString(),
                                      style: TextStyle(
                                          color: AppTheme.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    )),
                              ),
                              visible: OderCart.getOrderCartMap()
                                  .containsKey(
                                  categoryProduct[index].id),
                            ),
                            Visibility(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (categoryProduct[index]
                                        .count ==
                                        1) {
                                      categoryProduct[index].count =
                                      0;
                                      // total -= double.parse(categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price);
                                      OderCart.removeOrder(
                                          categoryProduct[index]
                                              .id);
                                      // calculateAmount();
                                    } else if (categoryProduct[
                                    index]
                                        .count >
                                        1) {
                                      // total -= double.parse(categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price);
                                      categoryProduct[index]
                                          .count -= 1;
                                      OderCart.putOrder(
                                          categoryProduct[index]);
                                      // calculateAmount();
                                    }
                                  });
                                },
                                child: Container(
                                  color: AppTheme.black,
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w500),
                                      )),
                                ),
                              ),
                              visible: OderCart.getOrderCartMap()
                                  .containsKey(
                                  categoryProduct[index].id),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          _getImageOrPlaceholder(
                              categoryProduct[index].image),
                          Text(
                            categoryProduct[index].title != null
                                ? categoryProduct[index].title
                                : "",
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 7.0),
                            // width: 92,
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppTheme.textLightColor),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    categoryProduct[index]
                                        .variants !=
                                        null
                                        ? categoryProduct[index]
                                        .variants[
                                    categoryProduct[
                                    index]
                                        .selectedVariantIndex] !=
                                        null
                                        ? categoryProduct[index]
                                        .variants[categoryProduct[
                                    index]
                                        .selectedVariantIndex]
                                        .weight !=
                                        null
                                        ? '${categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex]?.weight}'
                                        '${categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex]?.unitType}'
                                        : ""
                                        : ""
                                        : "",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                categoryProduct[index]
                                    .variants
                                    .length >
                                    1
                                    ? Material(
                                  child: InkWell(
                                      splashColor:
                                      Colors.grey,
                                      onTap: () {
                                        _askVariant(
                                            categoryProduct[
                                            index]
                                                .variants)
                                            .then((value) {
                                          setState(() {
                                            if (int.parse(
                                                value) !=
                                                categoryProduct[
                                                index]
                                                    .selectedVariantIndex) {
                                              categoryProduct[
                                              index]
                                                  .count = 0;
                                              OderCart.removeOrder(
                                                  categoryProduct[
                                                  index]
                                                      .id);
                                            }
                                            categoryProduct[
                                            index]
                                                .selectedVariantIndex =
                                                int.parse(
                                                    value);
                                          });
                                        });
                                      },
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                      )),
                                )
                                    : new Container(),
                              ],
                            ),
                          ),
                          Text(categoryProduct[index].variants !=
                              null
                              ? categoryProduct[index]
                              .variants[categoryProduct[
                          index]
                              .selectedVariantIndex] !=
                              null
                              ? categoryProduct[index]
                              .variants[categoryProduct[
                          index]
                              .selectedVariantIndex]
                              .price !=
                              null
                              ? '${AppUtils.getCurrencyPrice(double.parse(categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price.isNotEmpty ? categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price : "0.00") ?? 0)}'
                              : "0"
                              : "0"
                              : "0"),
                        ],
                      )
                    ],
                  ),
                ),
              )
                  : new Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Center(
                    child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor: AlwaysStoppedAnimation(
                                AppTheme.primaryColor)))),
              );
            }),
      ),
    )
        : new Container(
      // margin: EdgeInsets.only(bottom: 64.0),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Center(
          child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor:
                  AlwaysStoppedAnimation(AppTheme.primaryColor)))),
    );
  }

  Widget _getImageOrPlaceholder(imageUrl) {
    if (imageUrl != null) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/images/add_image_icon.png',
        image: imageUrl,
        width: 60.0,
        height: 60.0,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/add_image_icon.png',
            width: 60.0,
            height: 60.0,
          );
        },
      );
    }
    return Image.asset(
      'assets/images/add_image_icon.png',
      width: 60.0,
      height: 60.0,
    );
  }

  Future<String> _askVariant(List<Variants> variants) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: variants.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      variants[index].weight != null
                          ? '${variants[index].weight}  ${variants[index].unitType}'
                          : "--",
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      setState(() {
                        variantWeight = variants[index].weight;
                        variantUnittype = variants[index].unitType.toString();
                        variantPrice = variants[index].price;
                      });
                      Navigator.pop(context, index.toString());
                    },
                  );
                },
              ),
            ),
          );
        });
  }
}
