// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/apply_coupan_response.dart';
// import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/best_product_response.dart';
// import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/calculate_amount_response.dart';
// import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/calculate_shipping.dart';
// import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/product_response.dart';
// import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/user_response.dart';
// import 'package:marketplace_service_provider/src/components/dashboard/ui/add%20product/reedem_points_screen.dart';
// import 'package:marketplace_service_provider/src/components/dashboard/ui/dashboard_screen.dart';
// import 'package:marketplace_service_provider/src/network/add%20product/app_network.dart';
// import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
// import 'package:marketplace_service_provider/src/utils/app_constants.dart';
// import 'package:marketplace_service_provider/src/utils/app_theme.dart';
// import 'package:marketplace_service_provider/src/utils/app_utils.dart';
//
// import 'available_points.dart';
// import 'order_cart.dart';
//
// class CheckOut extends StatefulWidget {
//   var dateTime;
//   var customerId;
//   var instructions;
//   var shipping;
//   var userLoyalityPoints;
//   int orderType;
//   List<CustomerAddress> address;
//   CheckOut( {Key key, this.dateTime,this.customerId, this.instructions,this.shipping,
//     this.userLoyalityPoints,this.address, this.orderType} ) : super(key: key);
//
//   @override
//   _CheckOutState createState() => _CheckOutState();
// }
//
// class _CheckOutState extends State<CheckOut> {
//   List<PaymentSelect> _paymentValue = PaymentSelect.values;
//   List<ProductModel> productModels = [ProductModel()];
//   AmountData calculatedAmount;
//   List<Data> product = [Data()];
//   int _currentSelectedChip; double cartSaving;
//   String redeemCode,redeemPoint,paymentMode,redeemType;
//   String redeemAmount;double mrpDiscount = 0;
//   bool coupons=false,points=false, isOrder=true;
//   List<Data> orderList = OderCart.getOrderCartMap().values.toList();
//
//   @override
//   void initState() {
//     calculateAmount();
//     commonBus.on<OnRedeemCoupon>().listen((event) {
//       if(mounted)
//         setState(() {
//           redeemCode = event.code;
//           redeemAmount = event.amount;
//           redeemPoint = event.points;
//           redeemType = event.type;
//           if(redeemType =="1"){
//             if(redeemAmount!=null && redeemCode!=null){
//               points=true;
//               coupons=false;
//               if(double.parse(redeemPoint)<=double.parse(widget.userLoyalityPoints)){
//                 calculateAmount();
//               }else{
//                 points = false;
//                 redeemPoint=null;
//                 redeemAmount="0";
//               }
//             }else{
//               coupons=false;
//             }
//           }else {
//             if(redeemAmount!=null && redeemCode!=null){
//               if(double.parse(redeemAmount)<=double.parse(calculatedAmount.itemSubTotal)){
//                 points=false;
//                 coupons=true;
//                 applyCoupons();
//               }else{
//                 coupons = false;
//                 double result = double.parse(redeemAmount)-double.parse(calculatedAmount.itemSubTotal);
//                 EasyLoading.showToast('You have $result amount short for this offer',
//                     toastPosition: EasyLoadingToastPosition.bottom);
//                 redeemPoint=null;
//                 redeemAmount=null;
//               }
//             }else{
//               coupons=false;
//             }
//           }
//         });
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundGeryColor,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Checkout"),
//       ),
//       body: calculatedAmount!=null?
//       Stack(
//         children: [
//           SingleChildScrollView(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildItemTotal(),
//                   Container(
//                     width: double.infinity,
//                     color: CupertinoColors.systemGrey5,
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text("Select Payment Method"),
//                   ),
//                   Container(
//                     color: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           _buildPaymentsRow(),
//                           SizedBox(height: 16,),
//                           InkWell(
//                             onTap: (){
//                               if(coupons){
//                                 commonBus.fire(OnRedeemCoupon(null,null,null,null));
//                                 setState(() {
//                                   coupons = false;
//                                   redeemPoint=null;
//                                   redeemAmount="0";
//                                   calculateAmount();
//                                 });
//                               }else if(_currentSelectedChip==null){
//                                 EasyLoading.showToast('Select payment mode',
//                                     toastPosition: EasyLoadingToastPosition.bottom);
//                                 return false;
//                               }else if(redeemAmount!=null){
//                                 EasyLoading.showToast('Please remove existing discount first',
//                                     toastPosition: EasyLoadingToastPosition.bottom);
//                                 return false;
//                               }else{
//                                 // setState(() {
//                                 //   coupons = true;
//                                 // });
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => AvailablePoints(),
//                                     ));
//                               }
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(horizontal: 16,),
//                               width: double.infinity,
//                               height: 40,
//                               decoration:BoxDecoration(
//                                   color: AppTheme.chipsBackgroundColor,
//                                   borderRadius: BorderRadius.circular(25.0)),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(!coupons?"Apply Coupon":
//                                   "${redeemCode} Applied!",
//                                     style: TextStyle(
//                                       color: AppTheme.primaryColor,
//                                       fontSize: 14.0,
//                                     ),
//                                   ),
//                                   Icon(coupons?Icons.close:Icons.arrow_forward_ios,size:18,color: AppTheme.primaryColor,)
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 16,),
//                           Visibility(
//                             child: InkWell(
//                               onTap: (){
//                                 if(points){
//                                   commonBus.fire(OnRedeemCoupon(null,null,null,null));
//                                   setState(() {
//
//                                     points= false;
//                                     redeemPoint=null;
//                                     redeemAmount="0";
//                                     calculateAmount();
//                                   });
//                                   return false;
//                                 }else if(redeemAmount!=null){
//                                   EasyLoading.showToast('Please remove existing discount first',
//                                       toastPosition: EasyLoadingToastPosition.bottom);
//                                   return false;
//                                 }else{
//                                   // setState(() {
//                                   //   points = true;
//                                   // });
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => RedeemPoints(userId: widget.customerId,loyaltyPoints:widget.userLoyalityPoints),
//                                       ));
//                                 }
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 16),
//                                 width: double.infinity,
//                                 height: 40,
//                                 decoration:BoxDecoration(
//                                     color: AppTheme.chipsBackgroundColor,
//                                     borderRadius: BorderRadius.circular(25.0)),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(!points?
//                                     "Apply Loyalty Points":
//                                     "${redeemCode} Applied!",
//                                       style: TextStyle(
//                                         color: AppTheme.primaryColor,
//                                         fontSize: 14.0,
//                                       ),
//                                     ),
//                                     Icon(points?Icons.close:Icons.arrow_forward_ios,size:18,color: AppTheme.primaryColor,)
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             visible: widget.userLoyalityPoints!="",
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 100,)
//                 ],
//               ),
//             ),
//           ),
//           Container(
//               alignment: Alignment.bottomCenter,
//               width: MediaQuery.of(context).size.width,
//               child:
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: InkWell(
//                   onTap: ()=> _onOrder(),
//                   // onTap: isOrder?()=> _onOrder() : null,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 10.0),
//                     color: AppTheme.black,
//                     height: 50,
//                     child: Row(
//                       textBaseline: TextBaseline.alphabetic,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("${OderCart.getOrderCartMap().length.toString()} items",style: TextStyle(fontSize: 12,color: Colors.white),),
//                             Text("${AppUtils.getCurrencyPrice(double.parse(calculatedAmount!=null?
//                             calculatedAmount.total:"0")) ?? 0}",style: TextStyle(fontSize: 14,color: Colors.white),),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text("Checkout",style: TextStyle(fontSize: 16,color: Colors.white),),
//                             Icon(Icons.arrow_forward_ios, size: 25, color: Colors.white,)
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//           )
//         ],
//       ) : new Container(
//         // margin: EdgeInsets.only(bottom: 64.0),
//         margin: EdgeInsets.only(bottom: 16.0),
//         child: Center(
//             child: SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                     strokeWidth: 3.0,
//                     valueColor: AlwaysStoppedAnimation(
//                         AppTheme.primaryColor)))),
//       ),
//     );
//   }
//
//   _onOrder() {
//     setState(() {
//       isOrder = false;
//     });
//     if(widget.orderType==0){
//       return placeOrder();
//     }else{
//       return placeOrderPickDine();
//     }
//   }
//   Widget _buildItemTotal(){
//     return Container(
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Text("${OderCart.getOrderCartMap().length.toString()} items",style: TextStyle(fontSize: 12,),),
//             SizedBox(height: 10,),
//             _getItemList(),
//             Divider(
//               color: AppTheme.textLightColor,
//             ),
//             SizedBox(height: 10,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Total",style: TextStyle(color: AppTheme.black),),
//                 Text("${AppUtils.getCurrencyPrice(double.parse(calculatedAmount!=null?
//                 calculatedAmount.itemSubTotal:"0")) ?? 0}",style: TextStyle(color: AppTheme.black),),
//               ],),SizedBox(height: 10,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("MRP Discount",style: TextStyle(color: AppTheme.greenColor),),
//                 Text("${AppUtils.getCurrencyPrice(mrpDiscount ?? 0)}",style: TextStyle(color: AppTheme.greenColor),),
//               ],),SizedBox(height: 10,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Coupon Discount",style: TextStyle(color: AppTheme.greenColor),),
//                 Text("${AppUtils.getCurrencyPrice(double.parse(coupons?redeemAmount!=null?redeemAmount:"0.00":"0.00") ?? 0)}",style: TextStyle(color: AppTheme.greenColor),),
//               ],),SizedBox(height: 10,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 RichText(
//                   overflow: TextOverflow.clip,
//                   text: TextSpan(
//                       style: DefaultTextStyle.of(context).style,
//                       children: <TextSpan>[
//                         TextSpan(text: "Loyalty Points",
//                             style: TextStyle(color: AppTheme.black)
//                         ),
//                         TextSpan(
//                           text: points?
//                           "(${redeemPoint} Points)":"",
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: AppTheme.greenColor
//                           ),
//                         ),
//                       ]),
//                 ),
//                 Text(
//                   "${AppUtils.getCurrencyPrice(double.parse(points?redeemAmount!=null?redeemAmount:"0.00":"0.00") ?? 0)}"
//                   ,style: TextStyle(color: AppTheme.black),),
//               ],),SizedBox(height: 10,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Delivery Charges",style: TextStyle(color: AppTheme.black),),
//                 Text("${AppUtils.getCurrencyPrice(double.parse(calculatedAmount!=null?calculatedAmount.shipping:"0") ?? 0)}",style: TextStyle(color: AppTheme.black),),
//               ],),SizedBox(height: 10,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 RichText(
//                   overflow: TextOverflow.clip,
//                   text: TextSpan(
//                       style: DefaultTextStyle.of(context).style,
//                       children: <TextSpan>[
//                         TextSpan(text: "Tax & Charges",
//                             style: TextStyle(color: AppTheme.black)
//                         ),
//                         TextSpan(
//                           text:"",
//                           // "(${calculatedAmount.taxDetail.first.tax} Points)",
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: AppTheme.greenColor
//                           ),
//                         ),
//                       ]),
//                 ),
//                 // Text("Tax & Charges",style: TextStyle(color: AppTheme.black),),
//                 Text("${AppUtils.getCurrencyPrice(double.parse(calculatedAmount!=null?calculatedAmount.tax:"0") ?? 0)}",style: TextStyle(color: AppTheme.black),),
//               ],),SizedBox(height: 10,),
//             Divider(color: AppTheme.textLightColor,),
//             SizedBox(height: 10,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Payment Amount",style: TextStyle(color: AppTheme.black, fontSize: 14,fontWeight: FontWeight.w500),),
//                 Text("${AppUtils.getCurrencyPrice(double.parse(calculatedAmount!=null?calculatedAmount.total:"0") ?? 0)}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppTheme.black),),
//               ],),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(" ",style: TextStyle(fontSize: 10,color: AppTheme.greenColor),),
//                 Text("Cart Savings:${AppUtils.getCurrencyPrice(cartSaving ?? 0)}",style: TextStyle(fontSize: 10,color: AppTheme.greenColor),),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _getItemList(){
//     return  ListView.separated(
//       primary: false,
//       shrinkWrap: true,
//       itemCount:orderList.length,
//       itemBuilder: (context, index) {
//         int variantIndex = orderList[index].selectedVariantIndex;
//         var totalData = double.parse(variantIndex==null?
//         orderList[index].variants.first.price:
//         orderList[index].variants[variantIndex].price) *
//             orderList[index].count;
//         return index < OderCart.getOrderCartMap().length
//             ? Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(orderList[index].title,style: TextStyle(fontSize: 16,color: AppTheme.black),),
//             SizedBox(height: 8,),
//             Text("Weight: ${variantIndex ==null?orderList[index].variants.first.weight: orderList[index].variants[variantIndex].weight}"
//                 "${variantIndex ==null?orderList[index].variants.first.unitType:orderList[index].variants[variantIndex].unitType}",style: TextStyle(fontSize: 12,color: AppTheme.black),),
//             SizedBox(height: 8,),
//             Row(
//               mainAxisAlignment:MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 10.0,
//                       backgroundColor: Colors.grey[200],
//                       child: Text(orderList[index].count.toString(),style: TextStyle(fontSize: 12,color: AppTheme.black),),
//                     ),
//                     SizedBox(width: 10,),
//                     Text("${AppUtils.getCurrencyPrice(double.parse(variantIndex==null?
//                     orderList[index].variants.first.price:orderList[index].variants[variantIndex].price) ?? 0)}",style: TextStyle(fontSize: 12,color: AppTheme.black),),
//                   ],
//                 ),
//
//                 Text("${AppUtils.getCurrencyPrice(double.parse(totalData.toString()) ?? 0)}",style: TextStyle(fontSize: 14,color: AppTheme.black),),
//               ],
//             ),
//             // Text(OderCart.getOrderCartMap()[index].brand),
//           ],
//         )
//             : new Container(
//           // margin: EdgeInsets.only(bottom: 64.0),
//           margin: EdgeInsets.only(bottom: 16.0),
//           child: Center(
//               child: SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                       strokeWidth: 3.0,
//                       valueColor: AlwaysStoppedAnimation(
//                           AppTheme.primaryColor)))),
//         );
//       },
//       separatorBuilder: (context, index) {
//         return Divider(color: AppTheme.textLightColor,);
//       },
//     );
//   }
//   Widget _buildPaymentsRow() {
//     return GridView.builder(
//         shrinkWrap: true,
//         // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//             childAspectRatio: 4/3,
//             crossAxisSpacing: 8,
//             mainAxisSpacing: 8),
//         itemCount: _paymentValue.length,
//         itemBuilder: (BuildContext context, int index)  {
//           return InkWell(
//             onTap: (){
//               setState(() {
//                 _currentSelectedChip =index;
//                 paymentMode = _paymentValue[index].getTitle();
//               });
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5.0),
//                   border: Border.all(color: index == _currentSelectedChip
//                       ? AppTheme.primaryColor
//                       : AppTheme.chipsBackgroundColor,)
//               ),
//               child: Center(
//                   child: Text(' ${_paymentValue[index].getTitle()}',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: AppTheme.textLightColor,
//                       fontSize: 12.0,),
//                     overflow: TextOverflow.clip,)
//               ),
//             ),
//           );
//         });
//   }
//
//   calculateAmount(){
//     productModels.clear();
//     for (Data productData in  OderCart.getOrderCartMap().values){
//       ProductModel model = new ProductModel();
//       model.productId = productData.id;
//       model.productName = productData.title;
//       model.isTaxEnable = productData.isTaxEnable;
//       model.quantity = productData.count;
//
//       List<Variants> selectedVariant = productData.variants;
//       if(productData.selectedVariantIndex==null){
//         model.variantId = selectedVariant[0].id;
//         model.unitType = selectedVariant[0].unitType.toString();
//         model.mrpPrice = selectedVariant[0].mrpPrice;
//         model.weight = selectedVariant[0].weight;
//         model.discount = selectedVariant[0].discount;
//         model.price = selectedVariant[0].price;
//       }else{
//         int variantIndex = productData.selectedVariantIndex;
//         model.variantId = selectedVariant[variantIndex].id;
//         model.unitType = selectedVariant[variantIndex].unitType.toString();
//         model.mrpPrice = selectedVariant[variantIndex].mrpPrice;
//         model.weight = selectedVariant[variantIndex].weight;
//         model.discount = selectedVariant[variantIndex].discount;
//         model.price = selectedVariant[variantIndex].price;
//       }
//       productModels.add(model);
//     }
//     Map<String, dynamic> param = {
//       "user_id": widget.customerId,
//       "shipping": widget.shipping,
//       "discount": 0,
//       "tax": 0,
//       "fixed_discount_amount": redeemAmount,
//       "order_detail":jsonEncode(productModels),
//     };
//
//     AppNetwork.calculateAmount(param).then((value) => _handleTaxCalculationResponse(value),
//         onError: (error) => _handleError(error));
//   }
//
//   _handleTaxCalculationResponse(CalculateAmount value) {
//
//     if (value.success) {
//       setState(() {
//         calculatedAmount = value.data;
//         for (OrderDetailResponse response in calculatedAmount.orderDetail) {
//           double mrp = double.parse(response.mrpPrice);
//           double price = double.parse(response.price);
//           mrpDiscount += (mrp - price) * response.quantity;
//         }
//         cartSaving = mrpDiscount;
//         if(calculatedAmount.discount.isNotEmpty){
//           try {
//             cartSaving += double.parse(calculatedAmount.discount);
//           } catch (e) {
//             print(e);
//           }
//         }
//       });
//     }
//   }
//   applyCoupons()async{
//     productModels.clear();
//     for (Data productData in  OderCart.getOrderCartMap().values){
//       ProductModel model = new ProductModel();
//       model.productId = productData.id;
//       model.productName = productData.title;
//       model.isTaxEnable = productData.isTaxEnable;
//       model.quantity = productData.count;
//       List<Variants> selectedVariant = productData.variants;
//       if(productData.selectedVariantIndex==null){
//         model.variantId = selectedVariant[0].id;
//         model.unitType = selectedVariant[0].unitType.toString();
//         model.mrpPrice = selectedVariant[0].mrpPrice;
//         model.weight = selectedVariant[0].weight;
//         model.discount = selectedVariant[0].discount;
//         model.price = selectedVariant[0].price;
//       }else{
//         int variantIndex = productData.selectedVariantIndex;
//         model.variantId = selectedVariant[variantIndex].id;
//         model.unitType = selectedVariant[variantIndex].unitType.toString();
//         model.mrpPrice = selectedVariant[variantIndex].mrpPrice;
//         model.weight = selectedVariant[variantIndex].weight;
//         model.discount = selectedVariant[variantIndex].discount;
//         model.price = selectedVariant[variantIndex].price;
//       }
//       productModels.add(model);
//     }
//     Map<String, dynamic> deviceData = await AppUtils.initPlatformState();
//     var deviceId = Platform.isAndroid
//         ? deviceData['androidId']
//         : deviceData['identifierForVendor'];
//     String deviceToken = AppSharedPref.instance.getDeviceToken();
//
//     Map<String, dynamic> param = {
//       "platform": Platform.isAndroid
//           ? AppConstants.android
//           : AppConstants.iOS,
//       "payment_method": paymentMode,
//       "device_token": deviceToken,
//       "device_id": deviceId,
//       "user_id": widget.customerId,
//       "coupon_code": redeemCode,
//       "orders": jsonEncode(productModels),
//     };
//     AppNetwork.validateCoupon(param).then((value) => _handleApplyCouponResponse(value),
//         onError: (error) => _handleError(error));
//   }
//   _handleApplyCouponResponse(ApplyCouponResponse value) {
//     if (value.success) {
//       setState(() {
//         redeemAmount = value.discountAmount;
//         redeemCode = value.data.couponCode;
//         calculateAmount();
//         coupons =true;
//       });
//     }
//   }
//
//   placeOrderPickDine() async{
//     if (calculatedAmount == null) {
//       print("calculationamount == null");
//       return;
//     }
//     if(_currentSelectedChip==null){
//       EasyLoading.showToast('Select payment mode',
//           toastPosition: EasyLoadingToastPosition.bottom);
//       return false;
//     }
//     if(widget.customerId==null){
//       EasyLoading.showToast('user id is empty',
//           toastPosition: EasyLoadingToastPosition.bottom);
//       return false;
//     }
//     Map<String, dynamic> deviceData = await AppUtils.initPlatformState();
//     var deviceId = Platform.isAndroid
//         ? deviceData['androidId']
//         : deviceData['identifierForVendor'];
//     String deviceToken = AppSharedPref.instance.getDeviceToken();
//     Map<String, dynamic> param = {
//       "platform": "admin_android",
//       "payment_method": paymentMode=="Cash"?"cod":"online",
//       "device_token": deviceToken,
//       "device_id": deviceId,
//       "user_id": widget.customerId,
//       "coupon_code": redeemCode,
//       "online_method": paymentMode=="Cash"?"":paymentMode,
//       "user_address_id": widget.address.first.id!=null?widget.address.first.id:"1",
//       "total": calculatedAmount.total,
//       "user_address": widget.address.first.address,
//       "shipping_charges": calculatedAmount.shipping,
//       "discount": calculatedAmount.discount,
//       "cart_saving": cartSaving,
//       "checkout": calculatedAmount.itemSubTotal,
//       "wallet_refund": calculatedAmount.walletRefund,
//       "coupon_code": redeemCode,
//       "tax": calculatedAmount.tax,
//       "tax_rate": calculatedAmount.taxDetail.length>0?
//       calculatedAmount.taxDetail.first.rate:"0",
//       "store_tax_rate_detail": "",
//       "calculated_tax_detail": "",
//       "store_fixed_tax_detail": "",
//       "delivery_time_slot": "",
//       "orders": jsonEncode(calculatedAmount.orderDetail),
//       "order_facility": widget.orderType==1?"PickUp":"DineIn",
//     };
//     EasyLoading.show(dismissOnTap: false);
//     AppNetwork.pickupPlaceOrder(param).then((value) => _handlePlacePickUpORderResponse(value),
//         onError: (error) => _handleError(error));
//   }
//
//   placeOrder() async{
//     if (calculatedAmount == null) {
//       return;
//     }
//     if(_currentSelectedChip==null){
//       EasyLoading.showToast('Select payment mode',
//           toastPosition: EasyLoadingToastPosition.bottom);
//       return false;
//     }
//     Map<String, dynamic> deviceData = await AppUtils.initPlatformState();
//     var deviceId = Platform.isAndroid
//         ? deviceData['androidId']
//         : deviceData['identifierForVendor'];
//     String deviceToken = AppSharedPref.instance.getDeviceToken();
//
//     Map<String, dynamic> param = {
//       "platform": "admin_android",
//       "payment_method": paymentMode=="Cash"?"cod":"online",
//       "device_token": deviceToken,
//       "device_id": deviceId,
//       "user_id": widget.customerId,
//       "coupon_code": redeemCode!=null? redeemCode :"",
//       "online_method": paymentMode,
//       "user_address_id": widget.address.first.id!=null?
//       widget.address.first.id:"1",
//       "total": calculatedAmount.total,
//       "user_address":widget.address.first.address+','+widget.address.first.city+','+widget.address.first.state+','+widget.address.first.zipcode,
//       "shipping_charges": calculatedAmount.shipping,
//       "discount": calculatedAmount.discount,
//       "cart_saving": cartSaving,
//       "checkout": calculatedAmount.itemSubTotal,
//       "wallet_refund": calculatedAmount.walletRefund,
//       "coupon_code": redeemCode,
//       "tax": calculatedAmount.tax,
//       "delivery_time_slot": widget.dateTime,
//       "note": widget.instructions,
//       "tax_rate": calculatedAmount.taxDetail.length>0?
//       calculatedAmount.taxDetail.first.rate:"",
//       "store_tax_rate_detail": "",
//       "calculated_tax_detail": "",
//       "store_fixed_tax_detail": "",
//       "orders": jsonEncode(calculatedAmount.orderDetail),
//     };
//     EasyLoading.show(dismissOnTap: false);
//     AppNetwork.placeOrder(param).then((value) => _handlePlacePickUpORderResponse(value),
//         onError: (error) => _handleError(error));
//   }
//   _handlePlacePickUpORderResponse(CalculateShipping value){
//     EasyLoading.dismiss();
//     if(value.success){
//       OderCart.clearOrderCartMap();
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) =>  DashboardScreen()),);
//     }else{
//       EasyLoading.showToast(value.message,
//           toastPosition: EasyLoadingToastPosition.bottom);
//     }
//   }
//   void _handleError(error) {
//     EasyLoading.dismiss();
//     if (error is CustomException) {
//       EasyLoading.showToast(error.toString(),
//           toastPosition: EasyLoadingToastPosition.bottom);
//     }
//   }
//
// }
//
// enum PaymentSelect {
//   PAYTM,
//   CREDIT,
//   BHIMUPI,
//   GOOGLEPAY,
//   CASH,
// }
//
// extension OrderChipsExtension on PaymentSelect {
//   String getTitle() {
//     switch (this) {
//       case PaymentSelect.PAYTM:
//         return 'Paytm';
//       case PaymentSelect.CREDIT:
//         return 'Credit/Debit Card';
//       case PaymentSelect.BHIMUPI:
//         return 'BHIM UPI';
//       case PaymentSelect.GOOGLEPAY:
//         return 'Google Pay';
//       case PaymentSelect.CASH:
//       default:
//         return 'Cash';
//     }
//   }
//
// }