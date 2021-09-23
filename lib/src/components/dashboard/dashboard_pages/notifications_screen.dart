import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/network/connectivity/network_connection_observer.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/dashboard/repository/dashboard_repository.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() {
    return _NotificationScreenState();
  }
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoadingApi = false;
  var _notificationResponse;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grayCircle,
      appBar: BaseAppBar(
        callback: () {
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.black),
        ),
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
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
          child: isLoadingApi
              ? AppUtils.showSpinner()
              : ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, index) =>
                      _buildNotificationView(index),
                  itemCount: 10,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                )),
    );
  }

  _buildNotificationView(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Order Notification',
            style: TextStyle(
                color: AppTheme.mainTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.0),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
              'This is long description message'
              'for the order notification itemview',
              style: TextStyle(
                  fontSize: 14.0, color: AppTheme.subHeadingTextColor)),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                size: 14.0,
                color: AppTheme.subHeadingTextColor,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                  AppUtils.convertDateFromFormat(DateTime.now().toString(),
                      parsingPattern: AppUtils.dateTimeAppDisplayPattern_2),
                  style: TextStyle(
                      fontSize: 13.0, color: AppTheme.subHeadingTextColor)),
              SizedBox(
                width: 8.0,
              ),
              Icon(
                Icons.access_time,
                size: 16.0,
                color: AppTheme.subHeadingTextColor,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(AppUtils.convertTimeSlot(DateTime.now()),
                  style: TextStyle(
                      fontSize: 13.0, color: AppTheme.subHeadingTextColor)),
            ],
          )
        ],
      ),
    );
  }

  void _getNotifications() async {
    if (!getIt.get<NetworkConnectionObserver>().offline) {
      _notificationResponse =
          await getIt.get<DashboardRepository>().getNotifications(userId: 'id');
    } else {
      AppUtils.noNetWorkDialog(context);
    }
    setState(() {
      isLoadingApi = false;
    });
  }
}
