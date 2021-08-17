import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/account_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/home_screen.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/my_booking_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/side_menu_screen.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends BaseState<DashboardScreen> {
  int _selectedTabIndex = 0;

  List _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        callback: () {
          setState(() {
            _selectedTabIndex = 1;
          });
        },
      ),
      MyBookingScreen(),
      AccountScreen()
    ];
    initFirebase();

    try {
      appPrintLog("AppConstants.isLoggedIn=${AppConstants.isLoggedIn}");
      appPrintLog(
          "---login user---=${LoginUserSingleton.instance.loginResponse.data.id}");
      appPrintLog(
          "---login fullName---=${LoginUserSingleton.instance.loginResponse.data.fullName}");
    } catch (e) {
      print(e);
    }
    if (loginResponse.data.status == "1" &&
        loginResponse.afterApprovalFirstTime == "1") {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        AppUtils.displayPickUpDialog(context);
      });
    }
  }

  initFirebase() async{
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
    return Scaffold(
      body: _getNavigationMenu(),
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
            child: _pages[_selectedTabIndex],
          ),
          bottomNavigationBar: bottomNavigationBar,
        ));
  }

  //  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  void _toggle() {
    _innerDrawerKey.currentState.toggle(
        // direction is optional
        // if not set, the last direction will be used
        //InnerDrawerDirection.start OR InnerDrawerDirection.end
        direction: InnerDrawerDirection.start);
  }

  Widget get bottomNavigationBar {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 6),
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
                  image: AssetImage(AppImages.icon_account),
                  height: 22,
                  color: _selectedTabIndex == 2
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
      print("index..." + index.toString());
    });
  }

  _getAppBar() {
    switch (_selectedTabIndex) {
      case 1:
        return BaseAppBar(
          backgroundColor: AppTheme.white,
          title: Text(
            'My Bookings',
            style: TextStyle(color: AppTheme.black),
          ),
          leading: IconButton(
            iconSize: 20,
            color: AppTheme.white,
            onPressed: () => _toggle(),
            icon: Image(
              image: AssetImage(AppImages.icon_menu),
              height: 25,
              color: AppTheme.black,
            ),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 4,
          ),
        );
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
          appBar: AppBar(automaticallyImplyLeading: false, elevation: 0),
          widgets: <Widget>[
            Center(
              child: Badge(
                shape: BadgeShape.circle,
                showBadge: false,
                position: BadgePosition.topEnd(
                    top: Dimensions.getScaledSize(3),
                    end: Dimensions.getScaledSize(2)),
                borderRadius: BorderRadius.circular(5),
                child: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        );
    }
  }
}
