import 'dart:io';

import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/account_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/home_new_booking_request_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/home_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/my_booking_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/notifications_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/payment_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/ui/new_request_booking_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/side_menu_screen.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/utils/callbacks.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class DashboardScreen extends StatefulWidget {
  final bool shouldForceUpdate;

  DashboardScreen({Key key, this.shouldForceUpdate = false}) : super(key: key);

  @override
  _DashboardScreenState createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends BaseState<DashboardScreen> {
  int _selectedTabIndex = 0;
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
    initFirebase();
    // AppSharedPref.instance.setUserId("120");
    AppSharedPref.instance.getUserId();
    try {
      appPrintLog(
          "---login imagelink---=${AppSharedPref.instance.getUserProfileImage()}");
      appPrintLog("AppConstants.isLoggedIn=${AppConstants.isLoggedIn}");
      appPrintLog("---login user---=${AppSharedPref.instance.getUserId()}");
      appPrintLog(
          "---login fullName---=${AppSharedPref.instance.getUserName()}");
    } catch (e) {
      print(e);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (userId.data.status == "1" && userId.afterApprovalFirstTime == "1") {
      //   AppUtils.displayPickUpDialog(context);
      // }
      startLocationSetup(context);
      if (widget.shouldForceUpdate) {
        AppUtils.callForceUpdateDialog(
            context,
            VersionApiSingleton.instance.storeResponse.brand.name,
            VersionApiSingleton.instance.storeResponse.brand.forceDownload[0]
                .forceDownloadMessage,
            storeModel: VersionApiSingleton.instance.storeResponse.brand);
      }
    });
  }

  initFirebase() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          AppUtils.showToast('Please click BACK again to exit', false);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: _getNavigationMenu(),
      ),
    );
  }

  Widget _getNavigationMenu() {
    return InnerDrawer(
        key: _innerDrawerKey,
        onTapClose: true,
        swipe: true,
        colorTransitionChild: Colors.transparent,
        colorTransitionScaffold: Colors.black54,
        scale: IDOffset.horizontal(0.9),
        proportionalChildArea: true,
        borderRadius: 10,
        leftAnimationType: InnerDrawerAnimation.static,
        rightAnimationType: InnerDrawerAnimation.quadratic,
        backgroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.1, 0.5, 0.9],
            colors: [
              AppTheme.primaryColorDark,
              AppTheme.primaryColor,
              AppTheme.primaryColor,
            ],
          ),
        ),
        leftChild: SideMenuScreen(),
        scaffold: Scaffold(
          backgroundColor: AppTheme.white,
          appBar: _getAppBar(),
          body: Center(
            child: _getMainView(),
          ),
          bottomNavigationBar: bottomNavigationBar,
        ));
  }

  _getMainView() {
    switch (_selectedTabIndex) {
      case 0:
        return HomeScreen(
          callback: () {
            setState(() {
              _selectedTabIndex = 1;
            });
          },
        );
        break;
      case 1:
        return MyBookingScreen(
          menuInteraction: () {
            _toggle();
          },
        );
        break;
      case 2:
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           NewRequestBookingScreen(
        //             userId: userId,
        //           )),
        // );
        // if (refreshData != null && refreshData) {
        //   _refreshController.requestRefresh();
        // }


        return HomeNewBookingRequestScreen(() {
          _toggle();
        });

        break;
      case 3:
        return AccountScreen();
        break;
    }
  }

//  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  _toggle() {
    _innerDrawerKey.currentState.toggle(
        // direction is optional
        // if not set, the last direction will be used
        //InnerDrawerDirection.start OR InnerDrawerDirection.end
        direction: InnerDrawerDirection.start);
  }

  Widget get bottomNavigationBar {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 6),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: _changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle: TextStyle(
              fontFamily: AppConstants.fontName, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontFamily: AppConstants.fontName),
          selectedItemColor: AppTheme.primaryColorDark,
          unselectedItemColor: AppTheme.subHeadingTextColor,
          showUnselectedLabels: true,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(AppImages.icon_home),
                height: 22,
                color: _selectedTabIndex == 0
                    ? AppTheme.primaryColorDark
                    : AppTheme.subHeadingTextColor,
              ),
              label: labelHome,
            ),
            BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage(AppImages.icon_my_booking),
                  height: 22,
                  color: _selectedTabIndex == 1
                      ? AppTheme.primaryColorDark
                      : AppTheme.subHeadingTextColor,
                ),
                label: labelMyBooking),
            BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage(AppImages.icon_new_booking_request),
                  height: 22,
                  color: _selectedTabIndex == 2
                      ? AppTheme.primaryColorDark
                      : AppTheme.subHeadingTextColor,
                ),
                label: labelNewRequests),
            BottomNavigationBarItem(
                icon: Image(
                  image: AssetImage(AppImages.icon_account),
                  height: 22,
                  color: _selectedTabIndex == 3
                      ? AppTheme.primaryColorDark
                      : AppTheme.subHeadingTextColor,
                ),
                label: labelAccount),
          ],
        ));
  }

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  _getAppBar() {
    switch (_selectedTabIndex) {
      case 1:
        return null;
        break;
      case 2:
        return null;
        break;
      default:
        return BaseAppBar(
          backgroundColor: AppTheme.primaryColor,
          title: Text(''),
          leading: IconButton(
            iconSize: 20,
            color: AppTheme.white,
            onPressed: () => _toggle(),
            icon: Image(
              image: AssetImage(AppImages.icon_menu),
              height: 25,
            ),
          ),
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light),
            elevation: 0.0,
            titleSpacing: 0.0,
          ),
          widgets: <Widget>[
            Center(
              child: Badge(
                  shape: BadgeShape.circle,
                  showBadge: false,
                  position: BadgePosition.topEnd(
                      top: Dimensions.getScaledSize(3),
                      end: Dimensions.getScaledSize(2)),
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ));
                    },
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 25,
                    ),
                  )),
            ),
            SizedBox(
              width: 20,
            )
          ],
        );
    }
  }
}

startLocationSetup(BuildContext context) async {
  //TODO: manage location permission //check Duty is on
  bool isServiceEnable = await Geolocator.isLocationServiceEnabled();
  if (isServiceEnable) {
    LocationPermission permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    if (Platform.isAndroid && AppSharedPref.instance.getDutyStatus() == '1') {
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        if (permission == LocationPermission.whileInUse) {
          //TODO: Show better performance dialog
          // AppUtils.displayCommonDialog(context,
          //     title: labelErrorAlert,
          //     massage: labelBatterPerformanceMsg, positiveOnPressed: () async {
          //   Navigator.pop(context);
          //   await Geolocator.requestPermission();
          // });
          await Geolocator.requestPermission();
        }
        eventBus.fire(AlarmEvent.startPeriodicAlarm('start'));
      } else if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        //TODO: Show Dialog
        // AppUtils.displayCommonDialog(
        //   context,
        //   title: labelErrorAlert,
        //   massage: labelNeedPermission,
        // );
      }
    }
  } else {
    Geolocator.openAppSettings();
  }
}
