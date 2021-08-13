import 'package:flutter/material.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/login/model/login_response.dart';
import 'package:marketplace_service_provider/src/components/onboarding/select_category/presentation/ui/select_category_screen.dart';
import 'package:marketplace_service_provider/src/components/version_api/model/service_location_response.dart';
import 'package:marketplace_service_provider/src/sharedpreference/app_shared_pref.dart';
import 'package:marketplace_service_provider/src/singleton/login_user_singleton.dart';
import 'package:marketplace_service_provider/src/singleton/singleton_service_locations.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';
import '../bloc/save_location_bloc.dart';
import '../model/location_event_data.dart';

class ServicesLocationScreen extends StatefulWidget {
  final LoginResponse loginResponse;
  ServicesLocationScreen({this.loginResponse});
  @override
  _ServicesLocationScreenState createState() {
    return _ServicesLocationScreenState();
  }
}

class _ServicesLocationScreenState extends BaseState<ServicesLocationScreen> {

  final SaveLocationBloc saveLocationBloc = getIt.get<SaveLocationBloc>();
  int selectedCity = -1;

  @override
  void initState() {
    super.initState();
    saveLocationBloc.eventSink.add((LocationEventData(null,widget.loginResponse.data.id,LocationAction.SelectCity,selectedIndex:selectedCity)));
  }

  @override
  Widget builder(BuildContext context) {

    return StreamBuilder<LocationStreamOutput>(
        stream: saveLocationBloc.locationStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            LocationStreamOutput locationStreamOutput = snapshot.data;
            selectedCity = locationStreamOutput.selectedIndex;
            return WillPopScope(
              onWillPop: () {
                if(selectedCity == -1){
                  AppUtils.showToast("Please select city", false);
                  return;
                }
              },
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Color(0xFFECECEC),
                  body: Container(
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [0.1, 0.5, 0.7, 0.9],
                              colors: [
                                AppTheme.primaryColorDark,
                                AppTheme.primaryColor,
                                AppTheme.primaryColor,
                                AppTheme.primaryColor,
                              ],
                            ),
                          ),
                        ),
                        Container(
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topLeft:  const  Radius.circular(20.0),
                                    topRight: const  Radius.circular(20.0))
                            ),
                            margin: EdgeInsets.fromLTRB(20,  100, 20, 0),
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Column(
                              //padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              children: <Widget>[
                                Expanded(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: SingletonServiceLocations.instance.serviceLocationResponse.data.length,
                                      itemBuilder: (context, index) {
                                        ServiceLocationData object = SingletonServiceLocations.instance.serviceLocationResponse.data[index];
                                        return selectedCity != index
                                            ? ListTile(
                                          onTap: (){
                                            saveLocationBloc.eventSink.add((LocationEventData(object.id,widget.loginResponse.data.id,LocationAction.SelectCity,selectedIndex:index)));
                                          },
                                          title: Container(
                                            width: double.infinity,
                                            child: Text(object.name,style: TextStyle(fontFamily: AppConstants.fontName,),),
                                          ),
                                        )
                                            : ListTile(
                                          onTap: (){
                                            saveLocationBloc.eventSink.add((LocationEventData(object.id,widget.loginResponse.data.id,LocationAction.SelectCity,selectedIndex:index)));
                                          },
                                          title: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(object.name,style: TextStyle(color: AppTheme.primaryColor,
                                                    fontWeight: FontWeight.w600,fontFamily: AppConstants.fontName,),),
                                                  Icon(Icons.check,color: AppTheme.primaryColor)
                                                ],
                                              )
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider();
                                      },
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 50, right: 50,bottom: 25),
                                  width: MediaQuery.of(context).size.width,
                                  child: GradientElevatedButton(
                                    onPressed: (){
                                      validateAndSave(isSubmitPressed: true);
                                    },
                                    //onPressed: validateAndSave(isSubmitPressed: true),
                                    buttonText: labelSubmit,),
                                ),

                              ],
                            )
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 45, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Choose Area",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontFamily: AppConstants.fontName,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 30,height: 3,color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        });
  }

  validateAndSave({bool isSubmitPressed = false}) {
    if(selectedCity == -1){
      AppUtils.showToast("Please select city", false);
      return;
    }
    if(!isSubmitPressed){
      return;
    }
    if(this.network.offline){
      AppUtils.showToast(AppConstants.noInternetMsg, false);
      return;
    }
    ServiceLocationData object = SingletonServiceLocations.instance.serviceLocationResponse.data[selectedCity];
    saveLocationBloc.eventSink.add((LocationEventData(object.id,widget.loginResponse.data.id,LocationAction.SaveLocation)));

    saveLocationBloc.locationStream.listen((event) {
      if(event.showLoader){
        AppUtils.showLoader(context);
      }
      if(!event.showLoader){
        AppUtils.hideKeyboard(context);
        AppUtils.hideLoader(context);
        if(event.baseResponse != null){
          AppUtils.showToast(event.baseResponse.message, false);
          if(event.baseResponse.success){
            LoginResponse loginResponse = widget.loginResponse;
            Location location = new Location();
            location.locationId = object.id;
            location.locationName = object.name;
            loginResponse.location =location;
            LoginUserSingleton.instance.loginResponse = loginResponse;

            AppSharedPref.instance.saveUser(loginResponse).then((value) async {
              AppConstants.isLoggedIn = await AppSharedPref.instance.setLoggedIn(true);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => SelectCategoryScreen())
              );
            });
          }
        }
      }
    });
  }

}