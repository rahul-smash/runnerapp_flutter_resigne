import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/src/components/dashboard/dashboard_pages/home_screen.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
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

  List _pages = [
    HomeScreen(),
    Text("Order"),
    Text("Notfication"),
    Text("More"),
  ];

  @override
  void initState() {
    super.initState();
    try {
      print("AppConstants.isLoggedIn=${AppConstants.isLoggedIn}");
      print("---login user---=${LoginUserSingleton.instance.loginResponse.data.id}");
      print("---login fullName---=${LoginUserSingleton.instance.loginResponse.data.fullName}");
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(''),
        appBar: AppBar(),
        widgets: <Widget>[Icon(Icons.notifications,color: Colors.white,),SizedBox(width: 20,)],
      ),
      body: Center(
          child: _pages[_selectedTabIndex]
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
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
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedTabIndex,
            onTap: _changeIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: TextStyle(color: Colors.black),
            unselectedLabelStyle: TextStyle(color: Colors.white),
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.subHeadingTextColor,
            showUnselectedLabels: false,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text("Home",style: TextStyle(color: Colors.black),),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.article_rounded),
                title: new Text("Home",style: TextStyle(color: Colors.black),),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.image),
                title: new Text("Home",style: TextStyle(color: Colors.black),),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_rounded),
                title: new Text("Home",style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ));
  }
  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
      print("index..." + index.toString());
    });
  }

}
