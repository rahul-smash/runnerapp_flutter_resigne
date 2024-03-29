import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/src/model/store_response_model.dart';
import 'package:marketplace_service_provider/src/singleton/versio_api_singleton.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_images.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class AboutUsScreen extends StatefulWidget {
  AboutUsScreen();

  @override
  _AboutUsScreenState createState() {
    return _AboutUsScreenState();
  }
}

class _AboutUsScreenState extends BaseState<AboutUsScreen> {
  StoreResponse storeResponse;

  @override
  void initState() {
    super.initState();
    storeResponse = VersionApiSingleton.instance.storeResponse;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grayCircle,
      appBar: BaseAppBar(
        callback: () {
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text(
          'About Us',
          style: TextStyle(color: Colors.black),
        ),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark),
          elevation: 0.0,
          titleSpacing: 0.0,
          bottom: PreferredSize(
              child: Container(
                color: AppTheme.grayCircle,
                height: 4.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
        ),
        widgets: <Widget>[],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: VersionApiSingleton.instance.storeResponse.brand.aboutUs.isNotEmpty ?AppUtils.getHtmlView(
                  VersionApiSingleton.instance.storeResponse.brand.aboutUs):Container(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        color: AppTheme.white,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Follow Us",
                style: TextStyle(
                  color: AppTheme.mainTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.fontName,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                    visible: true,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: InkWell(
                        onTap: () {
                          AppUtils.launchURL(
                              storeResponse.brand.socialLinking.facebook);
                        },
                        child: Image.asset(
                          AppImages.icon_fb,
                          height: 25,
                        ),
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Visibility(
                    visible: true,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: InkWell(
                        onTap: () {
                          AppUtils.launchURL(
                              storeResponse.brand.socialLinking.twitter);
                        },
                        child: Image.asset(
                          AppImages.icon_twitter,
                          height: 25,
                        ),
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Visibility(
                    visible: true,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 10),
                      child: InkWell(
                        onTap: () {
                          AppUtils.launchURL(
                              storeResponse.brand.socialLinking.youtube);
                        },
                        child: Image.asset(
                          AppImages.icon_youTube,
                          height: 25,
                        ),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
