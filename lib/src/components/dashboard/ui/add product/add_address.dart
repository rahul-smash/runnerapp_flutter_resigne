import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/add_address_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/user_response.dart';
import 'package:marketplace_service_provider/src/network/add%20product/app_network.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';

class AddAddress extends StatefulWidget {
  var userId;
  var phone;
  var firstName;
  List<CustomerAddress> address;
  AddAddress( {Key key, this.address,this.userId,this.phone,this.firstName} ) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController  houseController = TextEditingController();
  TextEditingController  cityController = TextEditingController();
  TextEditingController  stateName = TextEditingController();
  TextEditingController  zipCodeController = TextEditingController();
  // List<CustomerAddress> productModels =[];
  List<CustomerAddress> productModels = [];
  CustomerAddress model = new CustomerAddress();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getAddress();
  }
  getAddress(){
    // print(SharedPrefs.getUserId());
    if(widget.address!=null){
      setState(() {
        houseController.text = widget.address.first.address;
        cityController.text = widget.address.first.city;
        stateName.text = widget.address.first.state;
        zipCodeController.text = widget.address.first.zipcode;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Address"),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Stack(
          children: [
            Container(
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4,),
                      TextField(
                        textInputAction: TextInputAction.done,
                        cursorColor: AppTheme.primaryColor,
                        style: TextStyle(
                          color: AppTheme.black,
                          fontSize: 16.0,
                        ),
                        keyboardType: TextInputType.name,
                        controller: houseController,
                        onChanged: (val)=>model.address = val,
                        decoration: InputDecoration(
                          labelText: 'Address Line1/House/Flat no.*',
                          contentPadding: const EdgeInsets.all(0.0),
                        ),
                      ), SizedBox(height: 10,),
                      TextField(
                        textInputAction: TextInputAction.done,
                        cursorColor: AppTheme.primaryColor,
                        style: TextStyle(
                          color: AppTheme.black,
                          fontSize: 16.0,
                        ),
                        keyboardType: TextInputType.name,
                        controller: cityController,
                        onChanged: (val)=>model.city = val,
                        decoration: InputDecoration(
                          labelText: 'Town/City*',
                          contentPadding: const EdgeInsets.all(0.0),
                        ),
                      ), SizedBox(height: 10,),
                      TextField(
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        cursorColor: AppTheme.primaryColor,
                        style: TextStyle(
                          color: AppTheme.black,
                          fontSize: 16.0,
                        ),
                        keyboardType: TextInputType.name,
                        controller: stateName,
                        onChanged: (val)=>model.state = val,
                        maxLines: 1,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0.0),
                            labelText: 'State*',
                            hintStyle: TextStyle(color: AppTheme.textLightColor)),
                      ),
                      TextField(
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        cursorColor: AppTheme.primaryColor,
                        style: TextStyle(
                          color: AppTheme.black,
                          fontSize: 16.0,
                        ),
                        keyboardType: TextInputType.number,
                        controller: zipCodeController,
                        onChanged: (val)=>model.zipcode = val,
                        maxLines: 1,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0.0),
                            labelText: 'Zip/Postal code',
                            hintStyle: TextStyle(color: AppTheme.textLightColor)),
                      ),
                    ],
                  ),
                )
            ),
            Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 8.0),
                child: RaisedButton(
                  onPressed: () async {
                    validAndSave();
                  },
                  textColor: Colors.white,
                  color: AppTheme.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  child: Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ))
          ],
        ),
      ),
    );
  }
  validAndSave(){
    if (!_isValid()) {
      return;
    }

    if(widget.address!=null){
      print("zip code");
      print(zipCodeController.text);
      if(widget.address.first.userId==null){
        setState(() {
          model.address = houseController.text;
          model.city = cityController.text;
          model.state = stateName.text;
          model.zipcode = zipCodeController.text;
          productModels.clear();
          productModels.add(model);
          print("address change");
          print(jsonEncode(productModels));
          commonBus.fire(OnAddAddress(productModels));
        });
        Navigator.pop(context, false);
        return;
      }
      Map<String, dynamic> param = {
        "user_id": widget.address.first.userId,
        "method": "edit",
        "first_name": widget.address.first.firstName,
        "mobile": widget.address.first.mobile,
        "address":houseController.text,
        "area_name": houseController.text,
        "area_id":"",
        "state": stateName.text,
        "city": cityController.text,
        "zipcode": zipCodeController.text,
        "address_id": widget.address.first.id,
      };

      EasyLoading.show(dismissOnTap: false);
      AppNetwork.deliveryAddress(param)
          .then(_handleAddAddressResponse, onError: _handleError);
      return;
    }
    //FOR CUSTOMER MODULE
    else if(widget.userId!=null){
      Map<String, dynamic> param = {
        "user_id": widget.userId,
        "method": "add",
        "first_name": widget.firstName,
        "mobile": widget.phone,
        "address":houseController.text,
        "area_name": houseController.text,
        "area_id":"",
        "state": stateName.text,
        "city": cityController.text,
        "zipcode": zipCodeController.text,
        "address_id": "",
      };
      EasyLoading.show(dismissOnTap: false);
      AppNetwork.deliveryAddress(param)
          .then(_handleAddAddressResponse, onError: _handleError);
      return;
    }
    else{
      setState(() {
        productModels.add(model);
        commonBus.fire(OnAddAddress(productModels));
        Navigator.pop(context, false);
      });
    }
  }
  void _handleError(error) {
    EasyLoading.dismiss();
    if (error is CustomException) {
      EasyLoading.showToast(error.toString(),
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
  _handleAddAddressResponse(AddAddressResponse value) {
    EasyLoading.dismiss();
    if(value.success){
      EasyLoading.showToast(value.message,
          toastPosition: EasyLoadingToastPosition.bottom);
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        Navigator.pop(context, true);
      });

    }else{
      EasyLoading.showToast(value.message,
          toastPosition: EasyLoadingToastPosition.bottom);
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        Navigator.pop(context, false);
      });
    }
  }
  bool _isValid() {
    String house = houseController.text.trim();
    if (house.isEmpty) {
      EasyLoading.showToast('Address is required',
          toastPosition: EasyLoadingToastPosition.bottom);
      return false;
    }
    if (cityController.text.isEmpty) {
      EasyLoading.showToast('City is required',
          toastPosition: EasyLoadingToastPosition.bottom);
      return false;
    }
    if (stateName.text.isEmpty) {
      EasyLoading.showToast('State is required',
          toastPosition: EasyLoadingToastPosition.bottom);
      return false;
    }
    if (stateName.text.isEmpty) {
      EasyLoading.showToast('Zip Code is required',
          toastPosition: EasyLoadingToastPosition.bottom);
      return false;
    }
    return true;
  }
}

