import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/booking_response.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';

class AddImageBottomSheet{

  AddImageBottomSheet(BuildContext context, Booking booking,
      Function callBackMethod, String type, String typeScreen){

  }
  openAddImageBottomSheet(context, String cashAmount) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.transparent,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(30.0),
                              topRight: const Radius.circular(30.0))),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        width: AppUtils.getDeviceWidth(context),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(AppImages.icon_thankyou_popup_bg),
                                fit: BoxFit.cover),
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(30.0),
                                topRight: const Radius.circular(30.0))),
                        child: Wrap(children: <Widget>[
                          Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      AppImages.icon_popupcancelicon,
                                      height: 20,
                                    )),
                              ),
                              Image.asset(
                                AppImages.icon_small_tick,
                                height: 100,
                              ),
                              Text(
                                'Payment Collected',
                                style: TextStyle(
                                    color: AppTheme.mainTextColor,
                                    fontSize: AppConstants.extraLargeSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Your transaction was successful.',
                                style: TextStyle(
                                    color: AppTheme.subHeadingTextColor,
                                    fontSize: AppConstants.smallSize,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: 80,
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ));
            },
          );
        });
  }

}