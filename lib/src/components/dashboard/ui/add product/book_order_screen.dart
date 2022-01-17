import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/best_product_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/calculate_amount_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/categories_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/product_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/edit_order_screen.dart';
import 'package:marketplace_service_provider/src/network/add%20product/app_network.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'order_cart.dart';
import 'order_type.dart';

double total=0;
class BookOrder extends StatefulWidget {
  var storeId;
  var customerId;
  var customerPhone;
  BookOrder({Key key, this.customerId,this.customerPhone,this.storeId}) : super(key: key);

  @override
  _BookOrderState createState() {
    return _BookOrderState();
  }
}

class _BookOrderState extends State<BookOrder> with TickerProviderStateMixin {
  static const PAGE_SIZE = 10;
  List<ProductModel> productModels = [ProductModel()];
  AmountData calculatedAmount;
  bool isExpanded =false;
  TextEditingController searchController = TextEditingController();
  int _currentPageNumber = 1, _start = 0, _totalOrders, id= 0;
  String selectedCategoryId = "";
  String selectedSubCategoryId = "";
  ScrollController _scrollController = ScrollController();
  Map<int, List<Data>> pageOrderMap = {};
  Map<int, List<Data>> pageProductMap = {};
  Map<int, List<Category>> pageCategoryMap = {};
  List<Data> productList = [];
  bool isClose = false;
  List<Data> categoryProduct = [];
  // List<Data> categoryProduct = [];
  String searchQuery='',imageUrl,variantPrice,variantWeight,variantUnittype;
  bool loading = false; int selected, counter= 0;
  bool showLoading = true;
  bool showList = false;
  List<SubCategory> _categoryList = [];
  TabController _tabController; double price =0;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2,initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    _initScrollListener();
    _getBestProducts();
    _getCategories(); cartDialog();
  }
  _handleTabSelection() {
    setState(() { });
    if( _tabController.index==0) {
      _currentPageNumber=1;
      pageOrderMap.clear();
      _totalOrders=0;
      _start=0;
      productList.clear();
      _getBestProducts();
    }else{
      _categoryList.clear();
      _getCategories();
      _getProducts();
    }

  }
  cartDialog(){
    if(OderCart.getOrderCartMap().length>0) {
      calculateAmount();
      return  Future.delayed(Duration.zero, () => showAlert(context));
    }
    return;
  }
  void _initScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!loading && _start < _totalOrders) {
          loading = !loading;
          _getBestProducts();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
              children:[
                // Icon(Icons.shopping_cart_rounded, color: AppColor.primaryColor,size: 30),
                Image.asset(
                  'assets/images/ic_launcher_foreground.png',
                  width: 50.0,
                  height: 60.0,
                ),
                Text('Proceed with existing cart?',style: TextStyle(fontSize: 16),)
              ]
          ),
          actions: <Widget>[
            TextButton(
              child: Text("CLEAR"),
              onPressed: () {
                setState(() {
                  _currentPageNumber=1;
                  pageOrderMap.clear();
                  _totalOrders=0;
                  _start=0;
                  productList.clear();
                  calculatedAmount =null;
                });
                OderCart.clearOrderCartMap();
                _getBestProducts();
                Navigator.of(context).pop();
              },
            ),

            TextButton(
              child: Text("YES"),
              onPressed: () {
                calculateAmount();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
                      variants[index].weight!=null?
                      '${variants[index].weight}  ${variants[index].unitType}':"",
                      overflow: TextOverflow.ellipsis,),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.primaryColor,
            elevation: 0.0,
            centerTitle: false,
            title:
            Text("Book Order"),
          ),
          backgroundColor: AppTheme.chipsBackgroundColor,
          body: Stack(
            children: [
              GestureDetector(
                onTap:  () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
                      child: TextField(
                          controller: searchController,
                          onSubmitted: (val) {
                            setState(() {
                              searchQuery = val;
                              _currentPageNumber=1;
                              pageOrderMap.clear();
                              _tabController.index==0 ?  productList.clear(): new Container() ;
                              _totalOrders=0;
                              _start=0;
                              _tabController.index==0 ?  _getBestProducts(): getcategorySearch() ;
                            });
                          },
                          onChanged: (val){
                            if(val!=null){
                              isClose =true;
                            }
                          },
                          style: new TextStyle(color: AppTheme.textLightColor,),
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none,
                                ),
                              ),
                              focusColor: AppTheme.primaryColor,
                              focusedBorder: InputBorder.none,
                              suffixIcon: Visibility(
                                child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        searchController.text = "";
                                        searchQuery= "";
                                        isClose = false;
                                        _tabController.index==0 ?  _getBestProducts(): _getCategories() ;
                                      });
                                    },
                                    child: Icon(Icons.close,color: AppTheme.textLightColor, size: 20,)),
                                visible: isClose,
                              ),
                              fillColor: AppTheme.chipsBackgroundColor, filled: true,
                              prefixIcon: Icon(Icons.search,color: AppTheme.textLightColor, size: 25,),
                              hintText: _tabController.index== 0 ? "Search for Product":"Search for Category" ,
                              hintStyle: new TextStyle(color: AppTheme.textLightColor))),
                    ),
                    Divider(
                      height: 2,
                    ),
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        isScrollable: false,
                        controller: _tabController,
                        labelColor: AppTheme.primaryColor,
                        unselectedLabelColor: AppTheme.textLightColor,
                        labelStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        unselectedLabelStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        indicatorColor: AppTheme.primaryColor,
                        tabs: [
                          Tab(
                            text: 'Best Sellers',
                          ),
                          Tab(
                            text: 'Categories',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                          controller: _tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [_buildProductView(), _buildCategoryView()]),
                    )
                  ],
                ),
              ),
              Visibility(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(bottom: 8.0),
                    child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => OrderType(customerId:widget.customerId,phone:widget.customerPhone),
                          //       // builder: (context) => EditBookingDetailsScreen(),//TODO uncomment  while merging
                          //     ));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
                          color: AppTheme.black,
                          height: 50,
                          child: Row(
                            textBaseline: TextBaseline.alphabetic,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text("${OderCart.getOrderCartMap().length.toString()} items",style: TextStyle(fontSize: 12,color: Colors.white),),
                                  // Text("${AppUtils.getCurrencyPrice(double.parse(calculatedAmount!=null?calculatedAmount.itemSubTotal:"0"))}",style: TextStyle(fontSize: 14,color: Colors.white),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Proceed",style: TextStyle(fontSize: 16,color: Colors.white),),
                                  Icon(Icons.arrow_forward_ios, size: 25, color: Colors.white,)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ),
                visible: OderCart.getOrderCartMap().length>0,
              )
            ],
          )
      ),
    );
  }

  int _getItemCount() {
    if (showLoading) {
      if (productList.isEmpty) {
        return 1;
      }
      if (productList.length < _totalOrders) {
        return productList.length + 1;
      }
    }
    return productList.length;
  }

  Widget _buildProductList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: productList.length >0 ?GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 6/9,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8),
              itemCount: _getItemCount(),
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return index < productList.length
                    ? InkWell(
                  onTap:(){
                    setState(() {
                      print(total);
                      productList[index].count +=1;
                      OderCart.putOrder(productList[index]);
                      price = double.parse(productList[index].variants[productList[index].selectedVariantIndex].price);
                      // total!=null? total+=price: total=price;
                      calculateAmount();
                    });
                  },
                  child: Container(
                    color:Colors.white,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          // left: 100,
                          right: 0,
                          child: Column(
                            children: [
                              Container(
                                color: AppTheme.black,
                                height:20, width: 20,
                                child: Center(child: Text("+",style: TextStyle(color: Colors.white,fontSize: 16),)),
                              ),
                              Visibility(
                                child: Container(
                                  height:20,width: 20,
                                  child: Center(child: Text(
                                    productList[index].count.toString(),
                                    style: TextStyle(color: AppTheme.black,
                                        fontWeight:FontWeight.w500,fontSize: 14),)),
                                ),
                                visible:  OderCart.getOrderCartMap().containsKey(productList[index].id),
                              ),
                              Visibility(
                                child: InkWell(
                                  onTap: (){
                                    setState(() {
                                      if(productList[index].count==1) {
                                        productList[index].count=0;
                                        // total -= double.parse(
                                        // productList[index].variants[productList[index].selectedVariantIndex].price);
                                        OderCart.removeOrder(productList[index].id);
                                        calculateAmount();
                                      }else if(productList[index].count>1){
                                        // fixme: count value is decrementing for view, but you are updating the cart here. if product count is more than 1 in the cart
                                        // total -= double.parse(
                                        // productList[index].variants[productList[index].selectedVariantIndex].price);
                                        productList[index].count-=1;
                                        OderCart.putOrder(productList[index]);
                                        calculateAmount();
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: AppTheme.black,
                                    height:20,width: 20,
                                    child: Center(child: Text("-",style: TextStyle(color: Colors.white,fontSize: 16,
                                        fontWeight: FontWeight.w500),)),
                                  ),
                                ),
                                visible: OderCart.getOrderCartMap().containsKey(productList[index].id),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _getImageOrPlaceholder(productList[index].image),
                            Text(productList[index].title!=null?productList[index].title:"", overflow: TextOverflow.ellipsis,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.textLightColor)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child:Text(
                                        productList[index].variants!=null ?
                                        productList[index].variants[productList[index].selectedVariantIndex]!=null?
                                        productList[index].variants[productList[index].selectedVariantIndex].weight!=null?
                                        '${productList[index].variants[productList[index].selectedVariantIndex]?.weight}'
                                            '${productList[index].variants[productList[index].selectedVariantIndex]?.unitType}':"":"":"",
                                        overflow: TextOverflow.ellipsis,),
                                    ),
                                    productList[index].variants.length>1?
                                    Material(
                                      child: InkWell(
                                          splashColor: Colors.grey,
                                          onTap: (){
                                            _askVariant(productList[index].variants).then((value) {
                                              setState(() {
                                                if(value!=null && int.parse(value) != productList[index].selectedVariantIndex){
                                                  productList[index].count= 0;
                                                  OderCart.removeOrder(productList[index].id);
                                                }
                                                productList[index].selectedVariantIndex = int.parse(value);
                                              });
                                            } );
                                          },
                                          child: Icon( Icons.arrow_drop_down,size: 20,)),
                                    )
                                        :new Container(),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              productList[index].variants!=null?
                              productList[index].variants[productList[index].selectedVariantIndex]!=null?
                              productList[index].variants[productList[index].selectedVariantIndex].price!=null?
                              '${AppUtils.getCurrencyPrice(double.parse(productList[index].variants[productList[index].selectedVariantIndex].price.isNotEmpty?
                              productList[index].variants[productList[index].selectedVariantIndex].price:"0.00") ?? 0)}':"0":"0":"0",),
                          ],
                        )
                      ],
                    ),
                  ),
                ) : new Container();
              }
          ): new Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Center(
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation(
                            AppTheme.primaryColor)))),
          ),
        )
      ],
    );
  }

  Widget _buildProductView() {
    return Stack(
      children: [
        _buildProductList(),
      ],
    );
  }

  Widget _buildCategoryView() {
    return Stack(
      children: [
        _buildCategoryList(),
      ],
    );
  }

  getcategorySearch(){
    print("searchQuery");
    print(searchQuery);
    _categoryList = searchQuery.isEmpty
        ? []
        : _categoryList != null
        ? _categoryList.where((SubCategory newtitle) {
      String _query = searchQuery.toLowerCase();
      String _getName = newtitle.title!=null?  newtitle.title.toLowerCase(): "";
      print(_getName);
      bool matchesName = _getName.contains(_query);
      print(matchesName);
      return (matchesName);}).toList():[];
    // setState(() {
    // searchQuery = '';
    // });
  }

  Widget  _buildCategoryList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16.0,
        ),
        Expanded(
          child: _categoryList.length>0?
          ListView.builder(
            itemCount: _categoryList.length,
            itemBuilder: (context, index) {
              return index < _categoryList.length
                  ?Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: ExpansionTile(
                    collapsedTextColor: AppTheme.black,
                    textColor: AppTheme.black,
                    trailing: Text(" "),
                    // key: Key(index.toString()),
                    // tilePadding: EdgeInsets.all(8.0),
                    initiallyExpanded: index == selected,
                    maintainState: false,
                    onExpansionChanged: (newState) {
                      setState(() {
                        if (newState) {
                          // this.isExpanded = newState;
                          selected = index;
                        }
                        else{
                          // this.isExpanded = false;
                          selected = -1;
                        }
                        selectedCategoryId = _categoryList[index].categoryId;
                        selectedSubCategoryId = _categoryList[index].id;
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
                        Icon(selected ==index?Icons.arrow_drop_up :Icons.arrow_drop_down, color: AppTheme.black,),
                        SizedBox(width: 8,),
                        Text(_categoryList[index].title,),
                      ],
                    ),
                    // textColor: AppColor.textDarkColor,
                    children: [
                      _categoryProduct(),
                    ],
                  ),
                ),
              ): new Container();
            },
          ) : new Container(
            // margin: EdgeInsets.only(bottom: 64.0),
            margin: EdgeInsets.only(bottom: 16.0),
            child: Center(
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor: AlwaysStoppedAnimation(
                            AppTheme.primaryColor)))),
          ),
        )
      ],
    );
  }

  Widget _categoryProduct(){
    return categoryProduct.length>0?
    Container(
      color: AppTheme.chipsBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
        child: GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 6/9,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8),
            itemCount: categoryProduct.length,
            itemBuilder: (BuildContext context, int index) {
              return index < categoryProduct.length ?
              InkWell(
                onTap:(){
                  setState(() {
                    categoryProduct[index].count+=1;
                    OderCart.putOrder(categoryProduct[index]);
                    price = double.parse(categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price);
                    // total!=null? total+=price: total=price;
                    calculateAmount();
                  });
                },
                child: Container(
                  color:Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0, left: 90, right: 0,
                        child: Column(
                          children: [
                            Container(
                              color: AppTheme.black,
                              height:20,width: 20,
                              child: Center(child: Text("+",style: TextStyle(color: Colors.white,fontSize: 16),)),
                            ),
                            Visibility(
                              child: Container(
                                height:20,width: 20,
                                child: Center(child: Text(categoryProduct[index].count.toString(),style: TextStyle(color: AppTheme.black,
                                    fontWeight:FontWeight.w500,fontSize: 14),)),
                              ),
                              visible: OderCart.getOrderCartMap().containsKey(categoryProduct[index].id),
                            ),
                            Visibility(
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    if(categoryProduct[index].count==1) {
                                      categoryProduct[index].count=0;
                                      // total -= double.parse(categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price);
                                      OderCart.removeOrder(categoryProduct[index].id);
                                      calculateAmount();
                                    }else if(categoryProduct[index].count>1){
                                      // total -= double.parse(categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price);
                                      categoryProduct[index].count-=1;
                                      OderCart.putOrder(categoryProduct[index]);
                                      calculateAmount();
                                    }
                                  });
                                },
                                child: Container(
                                  color: AppTheme.black,
                                  height:20,width: 20,
                                  child: Center(child: Text("-",style: TextStyle(color: Colors.white,fontSize: 16,
                                      fontWeight: FontWeight.w500),)),
                                ),
                              ),
                              visible:  OderCart.getOrderCartMap().containsKey(categoryProduct[index].id),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _getImageOrPlaceholder(categoryProduct[index].image),
                          Text(categoryProduct[index].title!=null?categoryProduct[index].title:"", overflow: TextOverflow.ellipsis,),
                          Container(
                            width: 92,
                            padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.textLightColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child:Text(
                                    categoryProduct[index].variants!=null ?
                                    categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex]!=null?
                                    categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].weight!=null?
                                    '${categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex]?.weight}'
                                        '${categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex]?.unitType}':"":"":"",
                                    overflow: TextOverflow.ellipsis,),
                                ),
                                categoryProduct[index].variants.length>1?
                                Material(
                                  child: InkWell(
                                      splashColor: Colors.grey,
                                      onTap: (){
                                        _askVariant(categoryProduct[index].variants).then((value) {
                                          setState(() {
                                            if(int.parse(value) != categoryProduct[index].selectedVariantIndex){
                                              categoryProduct[index].count= 0;
                                              OderCart.removeOrder(categoryProduct[index].id);
                                            }
                                            categoryProduct[index].selectedVariantIndex = int.parse(value);
                                          });
                                        } );
                                      },
                                      child: Icon( Icons.arrow_drop_down,size: 20,)),
                                )
                                    :new Container(),
                              ],
                            ),
                          ),
                          Text(categoryProduct[index].variants!=null?
                          categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex]!=null?
                          categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price!=null?
                          '${AppUtils.getCurrencyPrice(double.parse(categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price.isNotEmpty?categoryProduct[index].variants[categoryProduct[index].selectedVariantIndex].price:"0.00") ?? 0)}':"0":"0":"0"),
                        ],
                      )
                    ],
                  ),
                ),
              ) : new Container(
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
            }
        ),
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
                  valueColor: AlwaysStoppedAnimation(
                      AppTheme.primaryColor)))),
    );
  }

  Widget _getImageOrPlaceholder(imageUrl) {
    if (imageUrl != null ) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/images/add_image_icon.png',
        image: imageUrl,
        width: 60.0,
        height: 60.0,
        imageErrorBuilder:
            (context, error, stackTrace) {
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
  void _getProducts() async {
    Map<String, dynamic> param = {
      "page": 1,
      "pagelength": 1000,
      "cat_id": selectedCategoryId,
      "sub_cat_ids": selectedSubCategoryId,
    };

    AppNetwork.getCategoryProducts(param,storeID: widget.storeId).then((value) => _handleProductResponse(value),
        onError: (error) => _handleError(error));
  }
  /* _handleProductResponse(BestProduct value) {
    loading = false;
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
            getProductData.count = (selectedData.count);
            getProductData.selectedVariantIndex =
            (selectedData.selectedVariantIndex);
            break;
          }
          }
        }
      setState(() {
        categoryProduct = data;
      });
    }else {
      setState(() {
        showLoading = false;
        showList = false;
      });
      EasyLoading.showToast('No Data',
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }*/
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
      if(mounted){
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
    }else {
      setState(() {
        showLoading = false;
        showList = false;
        selected = -1;
      });
      EasyLoading.showToast('Data not found',
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
  void _getBestProducts() async {
    Map<String, dynamic> param = {
      "page": _currentPageNumber,
      "pagelength": PAGE_SIZE,
      "keyword": searchQuery
    };

    AppNetwork.getBestProducts(param,storeID: widget.storeId).then((value) => _handleBestProductResponse(value),
        onError: (error) => _handleError(error));
  }

  _handleBestProductResponse(BestProduct value) {
    loading = false;
    if (value.success) {
      pageOrderMap[_currentPageNumber] = value.data;
      List<Data> newList = [];
      pageOrderMap.forEach((key, value) {
        newList.addAll(value);
      });
      _currentPageNumber++;
      _totalOrders = int.tryParse(value.total) ?? 0;
      _start += PAGE_SIZE;
      List<Data> selectedProductList = [];
      if (!OderCart.isCartEmpty()) {
        selectedProductList.addAll(OderCart.getOrderCartMap().values.toList());
      }
      List<Data> data = value.data;
      for (Data getProductData in data) {
        for (Data selectedData in selectedProductList) {
          if (selectedData.id == getProductData.id) {
            getProductData.count = selectedData.count;
            print(selectedData.count);
            getProductData.selectedVariantIndex =
                selectedData.selectedVariantIndex;
            break;
          }
        }
      }
      setState(() {
        _currentPageNumber==1?
        productList = data
            :productList = productList + data;
      });
    } else {
      setState(() {
        showLoading = false;
        showList = false;
      });
      // EasyLoading.showToast('No Data',
      //     toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
  calculateAmount(){
    productModels.clear();
    for (Data productData in  OderCart.getOrderCartMap().values){
      ProductModel model = new ProductModel();
      model.productId = productData.id;
      model.productName = productData.title;
      model.isTaxEnable = productData.isTaxEnable;
      model.quantity = productData.count;

      List<Variants> selectedVariant = productData.variants;
      if(productData.selectedVariantIndex==null){
        model.variantId = selectedVariant[0].id;
        model.unitType = selectedVariant[0].unitType.toString();
        model.mrpPrice = selectedVariant[0].mrpPrice;
        model.weight = selectedVariant[0].weight;
        model.discount = selectedVariant[0].discount;
        model.price = selectedVariant[0].price;
      }else{
        int variantIndex = productData.selectedVariantIndex;
        model.variantId = selectedVariant[variantIndex].id;
        model.unitType = selectedVariant[variantIndex].unitType.toString();
        model.mrpPrice = selectedVariant[variantIndex].mrpPrice;
        model.weight = selectedVariant[variantIndex].weight;
        model.discount = selectedVariant[variantIndex].discount;
        model.price = selectedVariant[variantIndex].price;
      }
      productModels.add(model);
    }
    Map<String, dynamic> param = {
      "user_id": widget.customerId,
      "shipping": "0",
      "discount": 0,
      "tax": 0,
      "fixed_discount_amount": "0",
      "order_detail":jsonEncode(productModels),
    };

    AppNetwork.calculateAmount(param,storeID: widget.storeId).then((value) => _handleTaxCalculationResponse(value),
        onError: (error) => _handleError(error));
  }

  _handleTaxCalculationResponse(CalculateAmount value) {

    if (value.success) {
      setState(() {
        calculatedAmount = value.data;
      });
    } else {
      // EasyLoading.showToast('No Data',
      //     toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
  void _handleError(error) {
    EasyLoading.dismiss();
    if (error is CustomException) {
      EasyLoading.showToast(error.toString(),
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  void _getCategories() async {
    Map<String, dynamic> param = {"page": 1, "pagelength": 1000};
//TODO: send storeID
    AppNetwork.getCategories(param,storeID: widget.storeId).then(
            (value) => _handleCategoriesResponse(value),
        onError: (error) => _handleError(error));
    print("store id====${widget.storeId}");
  }

  _handleCategoriesResponse(CategoriesResponse value) {
    if (value.success) {
      List<SubCategory> subCategoryList = [];
      value.data.forEach((category) {
        category.subCategory.forEach((subcat) {
          subcat.categoryName = category.title;
          subcat.categoryId = category.id;
          subCategoryList.add(subcat);
        });
      });
      if(mounted)
        setState(() {
          _categoryList = subCategoryList;
        });
    }
  }


}
enum ProductType { BESTPRODUCT, CATEGORY }