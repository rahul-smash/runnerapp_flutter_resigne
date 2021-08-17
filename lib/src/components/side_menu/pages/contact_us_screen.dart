import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';
import 'package:marketplace_service_provider/src/widgets/base_appbar.dart';
import 'package:marketplace_service_provider/src/widgets/base_state.dart';

class ContactUsScreen extends StatefulWidget {
  ContactUsScreen();

  @override
  _ContactUsScreenState createState() {
    return _ContactUsScreenState();
  }
}

class _ContactUsScreenState extends BaseState<ContactUsScreen> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNameController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController messagetNameController = TextEditingController();

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
        title: Text('Contact Us',style: TextStyle(color: Colors.black),),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text("First Name*"),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Container(
                    //width: width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                            child: Icon(Icons.person),
                          ),
                          Expanded(
                            child: TextField(
                              controller: firstNameController,
                              textAlign: TextAlign.left,
                              decoration: new InputDecoration.collapsed(
                                hintText: "Enter your first Name",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Text("Last Name*"),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Container(
                    //width: width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                            child: Icon(Icons.person),
                          ),
                          Expanded(
                            child: TextField(
                              controller: lastNameController,
                              textAlign: TextAlign.left,
                              decoration: new InputDecoration.collapsed(
                                hintText: "Enter your last Name",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Text("Mobile*"),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Container(
                    //width: width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                            child: Icon(Icons.call),
                          ),
                          Expanded(
                            child: TextField(
                              controller: mobileNameController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.left,
                              decoration: new InputDecoration.collapsed(
                                hintText: "Enter your mobile number",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Text("Email*"),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Container(
                    //width: width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                            child: Icon(Icons.email),
                          ),
                          Expanded(
                            child: TextField(
                              controller: emailNameController,
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.left,
                              decoration: new InputDecoration.collapsed(
                                hintText: "Enter your email",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Text("City*"),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Container(
                    //width: width,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                            child: Icon(Icons.location_on),
                          ),
                          Expanded(
                            child: TextField(
                              controller: cityNameController,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.left,
                              decoration: new InputDecoration.collapsed(
                                hintText: "Enter your city",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Text("Write Your Message"),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: Container(
                    //width: width,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 15, 10.0, 0),
                            child: Icon(Icons.chat_bubble),
                          ),
                          Expanded(
                            child: TextField(
                              controller: messagetNameController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.left,
                              decoration: new InputDecoration.collapsed(
                                hintText: "Enter your message",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 20, 10),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: AppTheme.primaryColor)),
                    child: Text('Send Your Message'),
                    color: AppTheme.primaryColor,
                    textColor: Colors.white,
                    onPressed: () async {
                      if(this.network.offline){
                        AppUtils.showToast("No Internet connection!", true);
                        return;
                      }
                      if(firstNameController.text.trim().isEmpty){
                        AppUtils.showToast("Please enter first name", true);
                        return;
                      }
                      if(lastNameController.text.trim().isEmpty){
                        AppUtils.showToast("Please enter last name", true);
                        return;
                      }
                      if(mobileNameController.text.trim().isEmpty){
                        AppUtils.showToast("Please enter mobile number", true);
                        return;
                      }
                      if(emailNameController.text.isEmpty){
                        AppUtils.showToast("Please enter email", true);
                        return;
                      }
                      if(!AppUtils.validateEmail(emailNameController.text.trim())){
                        AppUtils.showToast("Please enter valid email", true);
                        return;
                      }
                      if(cityNameController.text.trim().isEmpty){
                        AppUtils.showToast("Please enter city", true);
                        return;
                      }


                      /*Utils.showProgressDialog(context);

                      String queryString = json.encode({
                        "name": "${firstNameController.text} ${lastNameController.text}",
                        "email": emailNameController.text,
                        "mobile": mobileNameController.text,
                        "city": cityNameController.text,
                        "datetime": "${Utils.getCurrentDateTime()}",
                        "message": messagetNameController.text
                      });

                      ApiController.setStoreQuery(queryString).then((response) {
                        Utils.hideProgressDialog(context);
                        if (response.success) {
                          Utils.hideProgressDialog(context);
                          ResponseModel resModel = response;
                          Utils.showToast(resModel.message , true);
                          Navigator.pop(context);
                        }
                      });*/

                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}