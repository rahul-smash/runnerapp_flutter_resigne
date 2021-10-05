import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/side_menu/model/help_videos_model.dart';
import 'package:marketplace_service_provider/src/components/side_menu/repository/menu_option_repository_impl.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class HelpVideoScreen extends StatefulWidget {
  HelpVideoScreen();

  @override
  _HelpVideoScreenState createState() {
    return _HelpVideoScreenState();
  }
}

class _HelpVideoScreenState extends BaseState<HelpVideoScreen> {
  @override
  Widget builder(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD),
      appBar: BaseAppBar(
        callback: () {
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text(
          'How to Video',
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
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          color: Color(0xFFFDFDFD),
          child: Column(
            children: [
              FutureBuilder<HelpVideosModel>(
                future: getIt
                    .get<MenuOptionRepositoryImpl>()
                    .getHowToVideos(), // async work
                builder: (BuildContext context,
                    AsyncSnapshot<HelpVideosModel> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Padding(
                        child: AppUtils.showSpinner(),
                        padding: EdgeInsets.only(top: 24.0),
                      );
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.data.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  /*showDialog(
                                      context: context,
                                      barrierColor: Color(0x00ffffff), //this works
                                      builder: (context) => VideoPlayerScreen(
                                        videoUrl: snapshot.data.data[index].videoUrl,
                                        title: snapshot.data.data[index].title,
                                      ),
                                    );*/
                                  AppUtils.launchURL(
                                      snapshot.data.data[index].videoUrl);
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  decoration: BoxDecoration(
                                      boxShadow: shadow,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      color: Color(0xFFFDFDFD)),
                                  child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 20, 10, 20),
                                      width: double.infinity,
                                      height: 100,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${snapshot.data.data[index].title}",
                                                      style: TextStyle(
                                                        color: AppTheme.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: AppConstants
                                                            .fontName,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "${snapshot.data.data[index].videoUrl}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF6DCEF9),
                                                        fontSize: 14,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: AppConstants
                                                            .fontName,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.share,
                                              color: AppTheme.primaryColor,
                                            ),
                                            onPressed: () {
                                              AppUtils.share(
                                                  "${snapshot.data.data[index].title}\n${snapshot.data.data[index].videoUrl}",
                                                  subject:
                                                      "${snapshot.data.data[index].title}");
                                            },
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            },
                          ),
                        );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
