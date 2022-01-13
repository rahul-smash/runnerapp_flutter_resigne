
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/coupan_response.dart';
import 'package:marketplace_service_provider/src/network/add%20product/app_network.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';

class AvailablePoints extends StatefulWidget {
  const AvailablePoints({Key key}) : super(key: key);

  @override
  _AvailablePointsState createState() => _AvailablePointsState();
}

class _AvailablePointsState extends State<AvailablePoints> {
  List<Data> coupons = [Data()];
  bool loading = false;
  bool showLoading = true;
  bool showList = false;
  @override
  void initState() {
    _getCoupons();
    // TODO: implement initState
    super.initState();
  }
  int _getItemCount() {
    if (showLoading) {
      if (coupons.isEmpty) {
        return 0;
      }

      if (coupons.length < 1) {
        return coupons.length ;
      }
    }
    return coupons.length;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGeryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Available Offers"),
      ),
      body: coupons.length>0 && coupons[0].id != null ?
      ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount:coupons.length,
        itemBuilder: (context, index) {
          if (coupons.length >0) {
            return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                            width: 35,
                            child: Text("${coupons[index].discount}% Off Upto ${AppUtils.getCurrencyPrice(double.parse(coupons[index].discountUpto!=null? coupons[index].discountUpto:"0"))}",overflow: TextOverflow.clip,)),
                        VerticalDivider(color: AppTheme.textLightColor,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              overflow: TextOverflow.clip,
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(text: "Use code ",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${coupons[index].couponCode}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.rejectColor
                                      ),
                                    ),
                                  ]),
                            ),
                            Text("to avail this offer",style: TextStyle(fontSize: 12,color: AppTheme.black),),
                            SizedBox(height: 10,),
                            Text("Min Order - ${AppUtils.getCurrencyPrice(double.parse(coupons[index].minimumOrderAmount!=null?coupons[index].minimumOrderAmount:"0"))}",
                              style: TextStyle(fontSize: 14,color: AppTheme.black),),
                            Text("Valid Till - ${coupons[index].validTo} ",style: TextStyle(fontSize: 14,color: AppTheme.black),),
                          ],
                        ),

                      ],
                    ),
                  ),

                  RaisedButton(
                    onPressed: () async {
                      _applyCoupon(coupons[index].minimumOrderAmount,coupons[index].couponCode);
                    },
                    textColor: Colors.white,
                    color: AppTheme.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                    child: Text(
                      'Apply',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  )
                ],
              ),
            ),
          );
          } else {
            return new Container(
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
        },

      ):new Container(),
    );
  }
  void _getCoupons() async {
    EasyLoading.show(dismissOnTap: false);
    AppNetwork.getCoupons().then((value) => _handleProductResponse(value),
        onError: (error) => _handleError(error));
  }
  _handleProductResponse(CouponResponse value) {
    EasyLoading.dismiss();
    loading = false;
    if (value.success) {
      if(mounted)
        setState(() {
          coupons = value.data;
        });
    } else {
      setState(() {
        commonBus.fire(OnRedeemCoupon(null,null,null,"0"));
        Navigator.pop(context);
      });
    }
  }
  _applyCoupon(String amount,code){
    setState(() {
      print(amount);
      commonBus.fire(OnRedeemCoupon(amount,code,null,"0"));
      Navigator.pop(context);
    });

  }
  void _handleError(error) {
    EasyLoading.dismiss();
    if (error is CustomException) {
      EasyLoading.showToast(error.toString(),
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

}
