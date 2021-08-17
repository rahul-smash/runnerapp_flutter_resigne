import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expandable/expandable.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class FaqScreen extends StatefulWidget {
  FaqScreen();

  @override
  _FaqScreenState createState() {
    return _FaqScreenState();
  }
}

class _FaqScreenState extends BaseState<FaqScreen> {

  @override
  void initState() {
    super.initState();
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
        callback: (){
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text('FAQ',style: TextStyle(color: Colors.black),),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark
          ),
          elevation: 0.0,
          titleSpacing: 0.0,
          bottom: PreferredSize(
              child: Container(
                color: AppTheme.grayCircle,
                height: 4.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
        ),
        widgets: <Widget>[
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(35.0))
        ),
        padding: EdgeInsets.only(top: 5,bottom: 5),
        child: Column(
          children: [
            Expanded(
                child: ExpandableTheme(
                  data: const ExpandableThemeData(
                    iconPlacement: ExpandablePanelIconPlacement.right
                  ),
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return faqCardView();
                      },
                      itemCount: 5,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

}

class faqCardView extends StatelessWidget {

  //FaqList questionAnserlist;
  faqCardView();

  @override
  Widget build(BuildContext context) {

    return ExpandableNotifier(
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
        child: ScrollOnExpand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expandable(
                collapsed: buildCollapsed1(context),
                expanded: buildCollapsed1(context),
              ),
              Expandable(
                collapsed: buildCollapsed3(),
                expanded: buildExpanded3(),
              ),
             Container(
               height: 1,
               margin: EdgeInsets.only(top: 20),
               color: AppTheme.grayCircle,
             )
            ],
          ),
        ),
      ),
    );
  }

  buildCollapsed1(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: Center(
                          child: Text("Which of the following numbers is farthest from the number 1 on the number line?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black,
                                fontFamily:AppConstants.fontName),
                          )
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        var controller = ExpandableController.of(context);
                        return FlatButton(
                          child: RotatedBox(
                            quarterTurns: controller.expanded ? 2 : 0,
                            child: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
                          ),
                          onPressed: () {
                            controller.toggle();
                          },
                        );
                      },
                    ),
                  ],
                )
                //SizedBox(height: 20,),
              ],
            ),
          ),
        ]
    );
  }

  buildCollapsed3() {
    return Container();
  }

  buildExpanded3() {
    //answer view
    return Padding(
      padding: EdgeInsets.only(left: 30,right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Which of the following numbers is farthest from the number 1 on the number line?",
              softWrap: true,
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppTheme.subHeadingTextColor,
                  fontFamily: AppConstants.fontName),
            ),
          )
        ],
      ),
    );
  }

}