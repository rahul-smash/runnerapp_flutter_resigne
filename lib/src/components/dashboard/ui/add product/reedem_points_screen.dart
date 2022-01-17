//
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/loyalty_response.dart';
// import 'package:marketplace_service_provider/src/network/add%20product/app_network.dart';
// import 'package:marketplace_service_provider/src/utils/app_theme.dart';
// import 'package:marketplace_service_provider/src/utils/app_utils.dart';
//
// class RedeemPoints extends StatefulWidget {
//   var userId;
//   var loyaltyPoints;
//   RedeemPoints({Key key, this.loyaltyPoints,this.userId}) : super(key: key);
//
//   @override
//   _RedeemPointsState createState() => _RedeemPointsState();
// }
//
// class _RedeemPointsState extends State<RedeemPoints> {
//   List<Data> loayltyPoints = [Data()];
//   bool loading = false;
//   bool showLoading = true;
//   bool showList = false;
//   ScrollController _scrollController = ScrollController();
//   @override
//   void initState() {
//     _getloyaltyPoints();
//     // TODO: implement initState
//     super.initState();
//   }
//   int _getItemCount() {
//     if (showLoading) {
//       if (loayltyPoints.isEmpty) {
//         return 1;
//       }
//
//       if (loayltyPoints.length < 1) {
//         return loayltyPoints.length + 1;
//       }
//     }
//
//     return loayltyPoints.length;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundGeryColor,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Redeem Points"),
//       ),
//       body: loayltyPoints.length>0 && loayltyPoints[0].id!=null?
//       ListView.builder(
//         primary: false,
//         shrinkWrap: true,
//         itemCount:loayltyPoints!=null?loayltyPoints.length:0,
//         itemBuilder: (context, index) {
//           return loayltyPoints!=null
//               ? Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(width: 10,),
//                       Text("${AppUtils.getCurrencyPrice(loayltyPoints[index].amount!=null?int.parse(loayltyPoints[index].amount):"0")} OFF for ${loayltyPoints[index].points} POints",style: TextStyle(fontSize: 14,color: AppTheme.black),),
//                       SizedBox(width: 10,),
//                       Text("Redeem for ${loayltyPoints[index].points} Points",style: TextStyle(fontSize: 14,color: AppTheme.greenColor),),
//                       SizedBox(width: 10,),
//                       Text("${loayltyPoints[index].couponCode}",style: TextStyle(fontSize: 14,color: AppTheme.greenColor),),
//                     ],
//                   ),
//                   RaisedButton(
//                     onPressed: () async {
//                       double lp = double.parse(widget.loyaltyPoints);
//                       double redeem = double.parse(loayltyPoints[index].points);
//                       if(lp < redeem){
//                         EasyLoading.showToast('Not Enough Loyalty Points',
//                             toastPosition: EasyLoadingToastPosition.bottom);
//                         Navigator.pop(context);
//                       }else{
//                         _redeemCode(loayltyPoints[index].couponCode,loayltyPoints[index].amount,
//                             loayltyPoints[index].points);
//                       }
//                     },
//                     textColor: Colors.white,
//                     color: AppTheme.black,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24.0)),
//                     child: Text(
//                       'Redeem',
//                       style: TextStyle(fontWeight: FontWeight.normal),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//               : new Container(
//             // margin: EdgeInsets.only(bottom: 64.0),
//             margin: EdgeInsets.only(bottom: 16.0),
//             child: Center(
//                 child: SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(
//                         strokeWidth: 3.0,
//                         valueColor: AlwaysStoppedAnimation(
//                             AppTheme.primaryColor)))),
//           );
//         },
//
//       ): new Container(),
//     );
//   }
//   void _getloyaltyPoints() async {
//     Map<String, dynamic> param = {"user_id": widget.userId};
//
//     EasyLoading.show(dismissOnTap: false);
//     AppNetwork.getLoyaltyPoints(param).then((value) => _handleProductResponse(value),
//         onError: (error) => _handleError(error));
//   }
//   _handleProductResponse(LoyaltyResponse value) {
//     EasyLoading.dismiss();
//
//     loading = false;
//     if (value.success) {
//       setState(() {
//         loayltyPoints = value.data;
//         print(loayltyPoints.length);
//       });
//     }
//   }
//   _redeemCode(String code, amount,points ){
//
//     setState(() {
//       print(amount);
//       commonBus.fire(OnRedeemCoupon(amount,code,points,"1"));
//       Navigator.pop(context);
//     });
//
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
