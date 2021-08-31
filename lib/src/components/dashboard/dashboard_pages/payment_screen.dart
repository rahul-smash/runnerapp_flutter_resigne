import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/dimensions/size_config.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/common_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends BaseState<PaymentScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String _selectedOverviewOption = 'Today';
  List<String> _overviewOptions = List.empty(growable: true);

  void _onRefresh() async {}

  @override
  void initState() {
    super.initState();
    _overviewOptions.add('Today');
    _overviewOptions.add('Yesterday');
    _overviewOptions.add('7 days');
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: AppTheme.primaryColor,toolbarHeight: 1,),
          // appBar: BaseAppBar(
          //   backgroundColor: AppTheme.primaryColor,
          //   title: Text(
          //     '',
          //     style: TextStyle(color: AppTheme.white),
          //   ),
          //   centerTitle: true,
          //   leading: IconButton(
          //     iconSize: 20,
          //     color: AppTheme.white,
          //     onPressed: () {},
          //     icon: Image(
          //       image: AssetImage(AppImages.icon_menu),
          //       height: 25,
          //       color: AppTheme.white,
          //     ),
          //   ),
          //   appBar: AppBar(
          //     automaticallyImplyLeading: false,
          //     elevation: 0,
          //     centerTitle: true,
          //   ),
          // ),
          backgroundColor: AppTheme.white,
          body: Container(
              child: Stack(
            children: [
              CommonWidgets.gradientContainer(
                  context,
                  150,
                  SizeConfig.screenWidth,
                  Container(
                    margin: EdgeInsets.only(
                        left: Dimensions.getScaledSize(45),
                        right: Dimensions.getScaledSize(45),
                        bottom: Dimensions.getScaledSize(45)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              SizedBox(height: 15,),
                              Text(
                                labelPayments,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.getScaledSize(
                                        AppConstants.extraLargeSize),
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 2,
                                width: 40,
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: SizeConfig.screenWidth,
                           child: Align(
                            alignment: Alignment.topRight,
                            child: PopupMenuButton(
                              elevation: 3.2,
                              iconSize: 5.0,
                              tooltip: 'Sorting',
                              child: Row(
                                children: [
                                  Text(
                                    _selectedOverviewOption,
                                    style: TextStyle(
                                        color: AppTheme.subHeadingTextColor,
                                        fontSize: AppConstants.smallSize,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    AppImages.icon_dropdownarrow,
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                              onSelected: (value) {
                                _selectedOverviewOption = value;
                                _refreshController.requestRefresh();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                              itemBuilder: (BuildContext context) {
                                return _overviewOptions.map((String choice) {
                                  return PopupMenuItem(
                                    value: choice,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          choice,
                                          style: TextStyle(
                                              color: _selectedOverviewOption ==
                                                  choice
                                                  ? AppTheme.primaryColorDark
                                                  : AppTheme.mainTextColor),
                                        ),
                                        Visibility(
                                            visible: _selectedOverviewOption ==
                                                choice,
                                            child: Icon(
                                              Icons.check,
                                              color: AppTheme.primaryColorDark,
                                            ))
                                      ],
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.0,
                    0.3,
                    0.7,
                    0.9
                  ],
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor,
                    AppTheme.primaryColorLight,
                    AppTheme.primaryColorLight
                  ]),
              Container(
                width: SizeConfig.screenWidth,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))),
                margin: EdgeInsets.only(top: Dimensions.getScaledSize(120)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(26),
                          Dimensions.getScaledSize(16),
                          Dimensions.getScaledSize(26),
                         0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Overview',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.getScaledSize(
                                      AppConstants.largeSize),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            child: PopupMenuButton(
                              elevation: 3.2,
                              iconSize: 5.0,
                              tooltip: 'Sorting',
                              child: Row(
                                children: [
                                  Text(
                                    _selectedOverviewOption,
                                    style: TextStyle(
                                        color: AppTheme.subHeadingTextColor,
                                        fontSize: AppConstants.smallSize,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    AppImages.icon_dropdownarrow,
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                              onSelected: (value) {
                                _selectedOverviewOption = value;
                                _refreshController.requestRefresh();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15.0))),
                              itemBuilder: (BuildContext context) {
                                return _overviewOptions
                                    .map((String choice) {
                                  return PopupMenuItem(
                                    value: choice,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          choice,
                                          style: TextStyle(
                                              color:
                                                  _selectedOverviewOption ==
                                                          choice
                                                      ? AppTheme
                                                          .primaryColorDark
                                                      : AppTheme
                                                          .mainTextColor),
                                        ),
                                        Visibility(
                                            visible:
                                                _selectedOverviewOption ==
                                                    choice,
                                            child: Icon(
                                              Icons.check,
                                              color:
                                                  AppTheme.primaryColorDark,
                                            ))
                                      ],
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(22),
                          0,
                          Dimensions.getScaledSize(22),
                          Dimensions.getScaledSize(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              shadowColor: AppTheme.borderOnFocusedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 4,
                              color: AppTheme.optionTotalCustomerBgColor,
                              margin: EdgeInsets.fromLTRB(
                                  Dimensions.pixels_5,
                                  0,
                                  Dimensions.pixels_5,
                                  0),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      AppImages.icon_totalearningfullicon,
                                      height: 27,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.pixels_10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              shadowColor: AppTheme.borderOnFocusedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 4,
                              color: AppTheme.optionTotalEarningColor,
                              margin: EdgeInsets.fromLTRB(
                                  Dimensions.pixels_5,
                                  0,
                                  Dimensions.pixels_5,
                                  0),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      AppImages.icon_totalearningfullicon,
                                      height: 27,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.pixels_10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          Dimensions.getScaledSize(22),
                          0,
                          Dimensions.getScaledSize(22),
                          Dimensions.getScaledSize(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              shadowColor: AppTheme.borderOnFocusedColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 4,
                              color: AppTheme.optionTotalBookingBgColor,
                              margin: EdgeInsets.fromLTRB(
                                  Dimensions.pixels_5,
                                  0,
                                  Dimensions.pixels_5,
                                  0),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      AppImages.icon_totalearningfullicon,
                                      height: 27,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.pixels_10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        );

  }
}
