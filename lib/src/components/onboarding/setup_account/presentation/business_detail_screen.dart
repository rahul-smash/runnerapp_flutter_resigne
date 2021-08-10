import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/core/dimensions/widget_dimensions.dart';
import 'package:marketplace_service_provider/core/service_locator.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/models/business_detail_model.dart';
import 'package:marketplace_service_provider/src/components/onboarding/setup_account/repository/account_steps_detail_repository_impl.dart';
import 'package:marketplace_service_provider/src/utils/app_constants.dart';
import 'package:marketplace_service_provider/src/utils/app_strings.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';
import 'package:marketplace_service_provider/src/widgets/gradient_elevated_button.dart';

class BusinessDetailScreen extends StatefulWidget {

  final VoidCallback voidCallback;
  BusinessDetailScreen({@required this.voidCallback});

  @override
  _BusinessDetailScreenState createState() {
    return _BusinessDetailScreenState();
  }
}

class _BusinessDetailScreenState extends BaseState<BusinessDetailScreen> {

  bool isLoading = false;
  BusinessDetailModel businessDetailModel;
  final _key = GlobalKey<FormState>();
  var businessNameCont = TextEditingController();
  var stateCont = TextEditingController();
  var pinCodeCont = TextEditingController();
  var cityCont = TextEditingController();
  var addressCont= TextEditingController();
  List<String> workLocationList = [];
  String _selectedWorkLocationTag;
  int valueHolder = 20;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getIt.get<AccountStepsDetailRepositoryImpl>().getBusinessDetail(loginResponse.data.id).then((value){
      businessDetailModel = value;
      workLocationList = businessDetailModel.data.serviceType;
      _selectedWorkLocationTag = workLocationList.first;
      setState(() {
        isLoading = false;
      });
    });
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
          widget.voidCallback();
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.white,
        title: Text('Business Detail',style: TextStyle(color: Colors.black),),
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
          Container(
            child: Center(child: Text("Save",style: TextStyle(color: Colors.black)),),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: SafeArea(
        child: isLoading ? AppUtils.showSpinner() : SingleChildScrollView(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),right: Dimensions.getScaledSize(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                        top: Dimensions.getScaledSize(20),bottom: Dimensions.getScaledSize(10)
                    ),
                    child: Text(
                      "Business Detail",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppTheme.subHeadingTextColor,
                        fontFamily: AppConstants.fontName,
                      ),
                    ),
                  ),

                  Form(
                    key: _key,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Container(
                      margin: EdgeInsets.only(left: Dimensions.getScaledSize(20),
                          right: Dimensions.getScaledSize(20),
                          bottom: Dimensions.getScaledSize(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: businessNameCont,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                            val.isEmpty ? "Please enter business name!" : null,
                            onFieldSubmitted: (value) {

                            },
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.borderNotFocusedColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.primaryColor)),
                              hintText: "Enter Business Name",
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor, fontSize: 16),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: stateCont,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (val) =>
                                  val.isEmpty ? "Please enter your state!" : null,
                                  onFieldSubmitted: (value) {

                                  },
                                  style: TextStyle(color: AppTheme.mainTextColor),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppTheme.borderNotFocusedColor)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppTheme.primaryColor)),
                                    hintText: "Enter State",
                                    errorStyle: TextStyle(
                                        fontSize: AppConstants.extraXSmallSize,
                                        fontFamily: AppConstants.fontName),
                                    hintStyle: TextStyle(
                                        color: AppTheme.subHeadingTextColor, fontSize: 16),
                                    labelStyle: TextStyle(
                                        color: AppTheme.mainTextColor, fontSize: 16),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: pinCodeCont,
                                  readOnly: true,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (val) =>
                                  val.isEmpty ? "Please enter your pincode!" : null,
                                  onTap: () async {

                                  },
                                  style: TextStyle(color: AppTheme.mainTextColor),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppTheme.borderNotFocusedColor)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppTheme.primaryColor)),
                                    hintText: "Pincode",
                                    errorStyle: TextStyle(
                                        fontSize: AppConstants.extraXSmallSize,
                                        fontFamily: AppConstants.fontName),
                                    hintStyle: TextStyle(
                                        color: AppTheme.subHeadingTextColor, fontSize: 16),
                                    labelStyle: TextStyle(
                                        color: AppTheme.mainTextColor, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: cityCont,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.send,
                            validator: (val) =>
                            val.isEmpty ? labelErrorMobileNumber : null,
                            onFieldSubmitted: (value) async {

                            },
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.borderNotFocusedColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.primaryColor)),
                              hintText: "Enter City",
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor, fontSize: 14),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: addressCont,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.send,
                            validator: (val) =>
                            val.isEmpty ? labelErrorEmail : null,
                            onFieldSubmitted: (value) async {

                            },
                            style: TextStyle(color: AppTheme.mainTextColor),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.borderNotFocusedColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.primaryColor)),
                              hintText: "Enter Address",
                              errorStyle: TextStyle(
                                  fontSize: AppConstants.extraXSmallSize,
                                  fontFamily: AppConstants.fontName),
                              hintStyle: TextStyle(
                                  color: AppTheme.subHeadingTextColor, fontSize: 14),
                              labelStyle: TextStyle(
                                  color: AppTheme.mainTextColor, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: DropdownButtonFormField(
                              dropdownColor: Colors.white,
                              items: workLocationList.map((String category) {
                                return new DropdownMenuItem(
                                    value: category,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          category,
                                          style: TextStyle(
                                              color: AppTheme.mainTextColor,
                                              fontFamily: AppConstants.fontName,
                                              fontSize: AppConstants.smallSize),
                                        ),
                                      ],
                                    ));
                              }).toList(),
                              onTap: () {},
                              onChanged: (newValue) {
                                // do other stuff with _category
                                setState(() => _selectedWorkLocationTag = newValue);
                              },
                              value: _selectedWorkLocationTag,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                filled: true,
                                fillColor: AppTheme.transparent,
                                focusColor: AppTheme.transparent,
                                hoverColor: AppTheme.transparent,
                                labelText: "I would like to work at",
                                labelStyle: TextStyle(fontSize: 16,color: AppTheme.subHeadingTextColor)
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 0,top: 10,bottom: 0 ),
                            child: Text(
                              "I would like to receive work within",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: AppTheme.subHeadingTextColor,
                                fontFamily: AppConstants.fontName,
                              ),
                            ),
                          ),

                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Slider(
                                  value: valueHolder.toDouble(),
                                  min: 1,
                                  max: 50,
                                  divisions: 50,
                                  activeColor: AppTheme.greenColor,
                                  inactiveColor: AppTheme.borderOnFocusedColor,
                                  label: '${valueHolder.round()}',
                                  onChanged: (double newValue) {
                                    setState(() {
                                      valueHolder = newValue.round();
                                    });
                                  },
                                  semanticFormatterCallback: (double newValue) {
                                    return '${newValue.round()}';
                                  }
                              )
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 30, right: 30,bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            child: GradientElevatedButton(
                              onPressed: () async {
                                if(this.network.offline){
                                  AppUtils.showToast(AppConstants.noInternetMsg, false);
                                  return;
                                }
                              },
                              //onPressed: validateAndSave(isSubmitPressed: true),
                              buttonText: labelSaveNext,),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}