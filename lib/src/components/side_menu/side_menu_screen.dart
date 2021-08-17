import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/src/components/login/ui/login_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/item_side_menu_child.dart';
import 'package:marketplace_service_provider/src/components/side_menu/pages/about_us_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/pages/contact_us_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/pages/faq_screen.dart';
import 'package:marketplace_service_provider/src/components/side_menu/pages/help_videos_screen.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class SideMenuScreen extends StatefulWidget {
  @override
  _SideMenuScreenState createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends BaseState<SideMenuScreen> {
  List<dynamic> _drawerItems = List.empty(growable: true);

  bool _isFollowUsExpanded = false;

  @override
  void initState() {
    super.initState();
    _drawerItems.add(ItemSideMenuChild(labelAboutUs, AppImages.icon_aboutus));
    _drawerItems.add(ItemSideMenuChild(labelContactUs, AppImages.icon_contactus));
    _drawerItems.add(ItemSideMenuChild(labelFaq, AppImages.icon_faq));
    _drawerItems.add(ItemSideMenuChild(labelHowToVideo, AppImages.icon_howtovideo));
  }

  @override
  Widget builder(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createHeaderInfoItem(),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _drawerItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return (createDrawerItem(_drawerItems[index], context));
                }),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    Dimensions.getScaledSize(10),
                    Dimensions.getScaledSize(15),
                    Dimensions.getScaledSize(10),
                    Dimensions.getScaledSize(15)),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Follow\nUs',
                      style: TextStyle(
                          fontFamily: AppConstants.fontName,
                          fontSize: AppConstants.smallSize,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Visibility(
                        visible: _isFollowUsExpanded,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: Image.asset(
                            AppImages.icon_fb,
                            height: 25,
                          ),
                        )),
                    Visibility(
                        visible: _isFollowUsExpanded,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Image.asset(
                            AppImages.icon_twitter,
                            height: 25,
                          ),
                        )),
                    Visibility(
                        visible: _isFollowUsExpanded,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 10),
                          child: Image.asset(
                            AppImages.icon_youTube,
                            height: 25,
                          ),
                        )),
                  ],
                ),
              ),
              Flexible(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    _isFollowUsExpanded = !_isFollowUsExpanded;
                  });
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      Dimensions.getScaledSize(5),
                      Dimensions.getScaledSize(18),
                      Dimensions.getScaledSize(5),
                      Dimensions.getScaledSize(18)),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                  ),
                  child: Image.asset(
                    AppImages.icon_follow_us,
                    color: AppTheme.white,
                    height: 10,
                  ),
                ),
              )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: AppTheme.primaryColorLight,
          ),
          Container(
            color: AppTheme.primaryColorDark,
            child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: ListTile(
                  leading: Image.asset(
                    AppImages.icon_logout,
                    color: AppTheme.white,
                    width: 20,
                    height: 35,
                  ),
                  title: Text(labelLogout,
                      style: TextStyle(
                          color: AppTheme.white,
                          fontSize: AppConstants.smallSize,
                          fontFamily: AppConstants.fontName)),
                  onTap: () async {
                    _showDialog(context);
                  },
                )),
          )
        ],
      ),
    );
  }

  void _showDialog(BuildContext sideMenuContext) {
    // flutter defined function
    showDialog(
      context: sideMenuContext,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout"),
          content: new Text('Are you sure you want to Logout?'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () async {
                Navigator.of(context).pop();
                await AppSharedPref.instance.sharepref.clear();
                AppConstants.isLoggedIn = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Widget createHeaderInfoItem() {
    return Container(
        padding: EdgeInsets.only(
            top: Dimensions.getScaledSize(40),
            bottom: Dimensions.getScaledSize(40),
            left: Dimensions.getScaledSize(20),
            right: Dimensions.getScaledSize(20)),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_circle,
                size: 60,
                color: Color(0xFFD6D6D6),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${loginResponse.data.fullName} ${loginResponse.data.lastName}",
                      style: TextStyle(
                          fontSize: Dimensions.getScaledSize(20),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white,
                          fontFamily: AppConstants.fontName),
                    ),
                    Text(
                      "${loginResponse.data.email}",
                      style: TextStyle(
                          fontSize: Dimensions.getScaledSize(16),
                          fontWeight: FontWeight.normal,
                          color: AppTheme.subHeadingTextColor,
                          fontFamily: AppConstants.fontName),
                    ),
                  ],
                ),
              ),
            ]));
  }

  Widget createDrawerItem(ItemSideMenuChild item, BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20),
        child: ListTile(
          leading: Image.asset(item.icon, color: AppTheme.white, width: 20),
          title: Text(item.title,
              style: TextStyle(color: AppTheme.white, fontSize: 15)),
          onTap: () {
            _openPageForIndex(item, context);
          },
        ));
  }

  void _openPageForIndex(ItemSideMenuChild item, BuildContext context) {
    print(item.title);
    if(item.title == labelAboutUs){
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => AboutUsScreen())
      );
    }else if(item.title == labelFaq){
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => FaqScreen())
      );
    }else if(item.title == labelContactUs){
      if(AppConstants.isLoggedIn)
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => ContactUsScreen())
      );
    }else if(item.title == labelHowToVideo){
        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => HelpVideoScreen())
        );
    }
  }
}
