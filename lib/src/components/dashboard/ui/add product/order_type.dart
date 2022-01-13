import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/add_address_response.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/calculate_shipping.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/delivery_slot.dart';
import 'package:marketplace_service_provider/src/components/dashboard/model/add%20product/user_response.dart';
import 'package:marketplace_service_provider/src/network/add%20product/app_network.dart';
import 'package:marketplace_service_provider/src/utils/app_theme.dart';
import 'package:marketplace_service_provider/src/utils/app_utils.dart';

import 'add_address.dart';
import 'add_customer_response.dart';
import 'checkout_screen.dart';

typedef SwitchOnChange = Function(int);

class OrderType extends StatefulWidget {
  var customerId;
  var phone;
  SwitchOnChange onChange;

  OrderType({this.onChange,this.customerId,this.phone});

  @override
  State<StatefulWidget> createState() {
    return OrderTypeState();
  }
}

class OrderTypeState extends State<OrderType> with TickerProviderStateMixin{
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController loayltyPoints = TextEditingController();
  TextEditingController pickmobileController = TextEditingController();
  TextEditingController picknameController = TextEditingController();
  TextEditingController pickemailController = TextEditingController();
  TextEditingController pickloayltyPoints = TextEditingController();
  TextEditingController dinemobileController = TextEditingController();
  TextEditingController dinenameController = TextEditingController();
  TextEditingController dineemailController = TextEditingController();
  TextEditingController dineloayltyPoints = TextEditingController();
  TextEditingController instructions = TextEditingController();
  TabController _orderTypeTabController;
  List<CustomerAddress> address = [CustomerAddress()];
  List<DateTimeCollection> dateTimeSlot = [DateTimeCollection()];
  List<Timeslot> timeSlot = [Timeslot()];
  AddCustomerType addType = AddCustomerType.DELIVERY;
  String lat,shipping,lng,userloayltyPoints,date,fullName,dateTime,userId;
  int _selectedIndex = 1;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }
  @override
  void initState() {
    super.initState();
    _getDeliverySlot();
    if(widget.phone!=null){
      _checkNumber();
    }
    commonBus.on<OnAddAddress>().listen((event) {
      if(mounted)
        setState(() {
          address.clear();
          address = event.address;
        });
    });
    _orderTypeTabController = new TabController(vsync: this, length: 3,initialIndex: 0);
    _orderTypeTabController.addListener(_handleTabSelection);
  }
  void _handleTabSelection() {
    setState(() { });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Book Order"),
          ),
          body: GestureDetector(
            onTap:  () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        child: TabBar(
                          isScrollable: false,
                          labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          automaticIndicatorColorAdjustment: false,
                          controller: _orderTypeTabController,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                          labelStyle:
                          TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                          unselectedLabelStyle:
                          TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                          indicatorColor: Colors.white,
                          // indicator: Dec,
                          tabs: [
                            Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top:10.0,right: 10.0),
                                  height:60,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(10.0,),
                                  ), width: double.infinity/1.2,
                                  child: Tab(
                                    text: 'Delivery',),),
                                Positioned(
                                  right: 0.0,
                                  child: Visibility(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: CircleAvatar(
                                        radius: 12.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.check_circle, color: AppTheme.black),
                                      ),
                                    ),
                                    visible: _orderTypeTabController.index==0,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top:10.0,right: 10.0),
                                  height:60,
                                  width: double.infinity/1.2,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(10.0,),
                                  ),
                                  child: Tab(
                                    text: 'Pick Up',
                                  ),
                                ),
                                Positioned(
                                  right: 0.0,
                                  child: Visibility(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: CircleAvatar(
                                        radius: 12.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.check_circle, color: AppTheme.black),
                                      ),
                                    ),
                                    visible: _orderTypeTabController.index==1,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top:10.0,right: 10.0),
                                  height:60,
                                  width: double.infinity/1.2,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(10.0,),
                                  ),
                                  child: Tab(
                                    text: 'Dine In',
                                  ),
                                ),
                                Positioned(
                                  right: 0.0,
                                  child: Visibility(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: CircleAvatar(
                                        radius: 12.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.check_circle, color: AppTheme.black),
                                      ),
                                    ),
                                    visible: _orderTypeTabController.index==2,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                          controller: _orderTypeTabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [_buildDelivery(),_buildPickUp(),_buildDineIn()]),
                    )
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
  _buildDelivery(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4,),
            TextField(
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(10),
              ],
              textInputAction: TextInputAction.search,
              cursorColor: AppTheme.primaryColor,
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16.0,
              ),
              onSubmitted: (val){
                addType = AddCustomerType.DELIVERY;
                _checkNumber();
              },
              keyboardType: TextInputType.number,
              controller: mobileController,
              decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  focusColor: AppTheme.black,
                  contentPadding: const EdgeInsets.all(0.0),
                  suffixIcon: InkWell(
                      onTap: (){
                        addType = AddCustomerType.DELIVERY;
                        _checkNumber();
                      },
                      child: Icon(Icons.search,size: 30,))
              ),
            ), SizedBox(height: 10,),
            TextField(
              textInputAction: TextInputAction.done,
              cursorColor: AppTheme.primaryColor,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                color:AppTheme.black,
                fontSize: 16.0,
              ),
              keyboardType: TextInputType.name,
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                contentPadding: const EdgeInsets.all(0.0),
              ),
            ), SizedBox(height: 10,),
            TextField(
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              cursorColor: AppTheme.primaryColor,
              readOnly: true,
              enabled: false,
              enableInteractiveSelection: true,
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16.0,
              ),
              keyboardType: TextInputType.name,
              controller: loayltyPoints,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0.0),
                  labelText: 'Available Loyalty Points',
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
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0.0),
                  labelText: 'Email',
                  hintStyle: TextStyle(color: AppTheme.textLightColor)),
            ),
            SizedBox(height: 10,),
            Visibility(
              child: RaisedButton(
                onPressed: () async {
                  bool refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAddress(userId: userId,
                            phone: mobileController.text,firstName: fullName),
                      ));
                  if (refresh) {
                    addType = AddCustomerType.DELIVERY;
                    _checkNumber();
                  }
                },
                textColor: AppTheme.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: AppTheme.black,
                      size: 20.0,
                    ),
                    SizedBox(width: 4.0,),
                    Text(
                      'Add Address',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              visible: address.first.city==null,
            ),
            SizedBox(height: 10,),
            Visibility(
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  color:  AppTheme.backgroundGeryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Deliver To",style:TextStyle(color: AppTheme.textLightColor)),
                          InkWell(
                              onTap: () async{
                                bool refresh = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddAddress(address : address),
                                    ));
                                if (refresh) {
                                  addType = AddCustomerType.DELIVERY;
                                  _checkNumber();
                                }
                              },
                              child: Text("Change",style:TextStyle(color: AppTheme.textLightColor))),
                        ],
                      ),
                      new Text(address!=null?address.first!=null?
                      "${address.first.address}":" ":" "
                          ,style:TextStyle(color: AppTheme.textLightColor)),
                      new Text(address!=null?address.first!=null?
                      "${address.first.city},${address.first.state}":" ":" ",style:TextStyle(color:AppTheme.textLightColor)),
                      new Text(address!=null?address.first!=null?
                      "${address.first.zipcode}":" ":" ",style:TextStyle(color: AppTheme.textLightColor)),
                    ],
                  )
              ),
              visible: address.first.city!=null,
            ),
            SizedBox(height: 10,),
            Visibility(child: Text("Delivery Slot", style: TextStyle(fontSize: 16),),
              visible: dateTimeSlot!=null && dateTimeSlot.length>1,),
            SizedBox(height: 5,),
            Visibility(child: Divider(color: AppTheme.chipsBackgroundColor,),
              visible:  dateTimeSlot!=null && dateTimeSlot.length>1,),
            SizedBox(height: 5,),
            Visibility(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(dateTimeSlot!=null?dateTimeSlot.length:0, (index) {
                    return InkWell(
                      focusColor: AppTheme.chipsBackgroundColor,
                      onTap: (){
                        setState(() {
                          _onSelected(index);
                          timeSlot = dateTimeSlot[index].timeslot;
                          date = DateFormat('yyyy-MM-dd').format(DateFormat("dd MMM yyyy").parse(dateTimeSlot[index].label!=null?dateTimeSlot[index].label:"01 Jan 2021"));
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '${ DateFormat('dd MMM').format(DateFormat("dd MMM").parse(dateTimeSlot[index].label!=null?dateTimeSlot[index].label:"01 Jan 2021"))}', style: TextStyle(
                          color: _selectedIndex != null && _selectedIndex == index ?
                          AppTheme.greenColor : Colors.black,
                        ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              visible: dateTimeSlot!=null && dateTimeSlot.length>1,
            ),
            SizedBox(height: 5,),
            Visibility(
              child: Divider(
                color: AppTheme.chipsBackgroundColor,
              ),
              visible:  dateTimeSlot!=null && dateTimeSlot.length>1,
            ),
            SizedBox(height: 5,),
            Visibility(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(timeSlot!=null?timeSlot.length:0, (index) {
                    return InkWell(
                      focusColor: AppTheme.chipsBackgroundColor,
                      onTap: (){
                        setState(() {
                          if(timeSlot[index].isEnable==true){
                            dateTime = date+","+timeSlot[index].value;
                          }else{
                            EasyLoading.showToast(timeSlot[index].innerText.toString(),
                                toastPosition: EasyLoadingToastPosition.bottom);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Text(
                              '${ timeSlot[index].label}', style: TextStyle(
                              color: timeSlot[index].isEnable==true?
                              AppTheme.lightGreenColor : Colors.black,
                            ),
                            ),
                            Text(timeSlot[index].isEnable==false?
                            '(${ timeSlot[index].innerText})':"", style: TextStyle(
                              color: Colors.black,
                            ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ) ,
              ),
              visible: dateTimeSlot!=null && dateTimeSlot.length>1,
            ),
            SizedBox(height: 10,),
            Container(
                color:  AppTheme.backgroundGeryColor,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  maxLines: 3,
                  controller: instructions,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      fillColor: AppTheme.backgroundGeryColor,
                      filled: true,
                      border: InputBorder.none,
                      hintText: "Delivery Instructions"
                  ),
                )
            ),
            SizedBox(height: 10,),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 8.0),
                child: RaisedButton(
                  onPressed: () async {
                    addType = AddCustomerType.DELIVERY;
                    validAndSave();
                  },
                  textColor: Colors.white,
                  color:AppTheme.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  child: Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ))
          ],
        ),
      ),
    );
  }
  _buildPickUp(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4,),
            TextField(
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(10),
              ],
              textInputAction: TextInputAction.search,
              cursorColor: AppTheme.primaryColor,
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16.0,
              ),
              onSubmitted: (val){
                addType = AddCustomerType.PICKUP;
                _checkNumber();
              },
              keyboardType: TextInputType.number,
              controller: pickmobileController,
              // onTap: _categories,
              decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  contentPadding: const EdgeInsets.all(0.0),
                  suffixIcon: InkWell(
                      onTap:(){
                        addType = AddCustomerType.PICKUP;
                        _checkNumber();
                      },
                      child: Icon(Icons.search,size: 30,))
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
              textCapitalization: TextCapitalization.words,
              controller: picknameController,
              decoration: InputDecoration(
                labelText: 'Name',
                contentPadding: const EdgeInsets.all(0.0),
              ),
            ), SizedBox(height: 10,),
            TextField(
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              cursorColor: AppTheme.primaryColor,
              readOnly: true,
              enabled: false,
              enableInteractiveSelection: true,
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16.0,
              ),
              keyboardType: TextInputType.name,
              controller: pickloayltyPoints,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0.0),
                  labelText: 'Available Loyalty Points',
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
              keyboardType: TextInputType.emailAddress,
              controller: pickemailController,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0.0),
                  labelText: 'Email',
                  hintStyle: TextStyle(color: AppTheme.textLightColor)),
            ),
            SizedBox(height: 10,),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 8.0),
                child: RaisedButton(
                  onPressed: () async {
                    addType = AddCustomerType.PICKUP;
                    validAndSave();
                  },
                  textColor: Colors.white,
                  color: AppTheme.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  child: Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ))
          ],
        ),
      ),
    );
  }
  _buildDineIn(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4,),
            TextField(
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(10),
              ],
              textInputAction: TextInputAction.search,
              cursorColor: AppTheme.primaryColor,
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16.0,
              ),
              onSubmitted: (val){
                addType = AddCustomerType.DINEIN;

                _checkNumber();
              },
              keyboardType: TextInputType.number,
              controller: dinemobileController,
              decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  contentPadding: const EdgeInsets.all(0.0),
                  suffixIcon: InkWell(
                      onTap:(){
                        addType = AddCustomerType.DINEIN;
                        _checkNumber();
                      },
                      child: Icon(Icons.search,size: 30,))
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
              controller: dinenameController,
              decoration: InputDecoration(
                labelText: 'Name',
                contentPadding: const EdgeInsets.all(0.0),
              ),
            ), SizedBox(height: 10,),
            TextField(
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              cursorColor: AppTheme.primaryColor,
              readOnly: true,
              enabled: false,
              enableInteractiveSelection: true,
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 16.0,
              ),
              keyboardType: TextInputType.name,
              controller: dineloayltyPoints,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0.0),
                  labelText: 'Available Loyalty Points',
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
              keyboardType: TextInputType.emailAddress,
              controller: dineemailController,
              maxLines: 1,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0.0),
                  labelText: 'Email',
                  hintStyle: TextStyle(color: AppTheme.textLightColor)),
            ),
            SizedBox(height: 10,),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 8.0),
                child: RaisedButton(
                  onPressed: () async {
                    addType = AddCustomerType.DINEIN;
                    validAndSave();
                  },
                  textColor: Colors.white,
                  color: AppTheme.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  child: Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  _getDeliverySlot(){
    Map<String, dynamic> param = {
      "store_id": store_id,
    };
    EasyLoading.show(dismissOnTap: false);
    AppNetwork.getDeliverySlots(param)
        .then(_handleDeliverySlotsResponse, onError: _handleError);
  }

  _handleDeliverySlotsResponse(DeliverySlot value) {
    EasyLoading.dismiss();
    if (value.success) {
      setState(() {
        dateTimeSlot = value.data.dateTimeCollection;
        if(dateTimeSlot!=null && dateTimeSlot.length>0){
          timeSlot = dateTimeSlot[1].timeslot;
          date = DateFormat('yyyy-MM-dd').format(DateFormat("dd MMM yyyy").parse(dateTimeSlot[1].label!=null?dateTimeSlot[1].label:"01 Jan 2021"));
          dateTime = date+","+timeSlot[0].value;
        }
      });
    }
  }
  validAndSave(){
    if (!_isValid()) {
      return;
    }
    _checkNumberOnNExt();
  }

  void addCustomer() {
    if (!_isValid()) {
      return;
    }
    switch (addType) {
      case AddCustomerType.DELIVERY:
        Map<String, dynamic> param = {
          "name": nameController.text,
          "email": emailController.text,
          "mobile": mobileController.text,
          "address": address.first.address,
          "area_name":address.first.areaName,
          "area_id":address.first.id,
          "state": address.first.state,
          "city": address.first.city,
          "zipcode": address.first.zipcode,
        };
        EasyLoading.show(dismissOnTap: false);
        AppNetwork.addCustomer(param)
            .then(_handleAddCustomerResponse, onError: _handleError);

        break;
      case AddCustomerType.PICKUP:
        Map<String, dynamic> param = {
          "name": picknameController.text,
          "email": pickemailController.text,
          "mobile": pickmobileController.text,
          "address": "",
          "area_name":"",
          "area_id":"",
          "state": "",
          "city": "",
          "zipcode": ""
        };
        EasyLoading.show(dismissOnTap: false);
        AppNetwork.addCustomer(param)
            .then(_handleAddCustomerResponse, onError: _handleError);
        break;
      case AddCustomerType.DINEIN:
        Map<String, dynamic> param = {
          "name": dinenameController.text,
          "email": dineemailController.text,
          "mobile": dinemobileController.text,
          "address": "",
          "area_name":"",
          "area_id":"",
          "state": "",
          "city": "",
          "zipcode": ""
        };
        EasyLoading.show(dismissOnTap: false);
        AppNetwork.addCustomer(param)
            .then(_handleAddCustomerResponse, onError: _handleError);
        break;
    }
  }
  _handleAddCustomerResponse(AddCustomerResponse value) async {
    EasyLoading.dismiss();

    if (value.success) {
      setState(() {
        userloayltyPoints = "";
        userId = value.data.storeUser.userId;
      });
      CustomerAddress nAddress = CustomerAddress();
      if(value.data.address!=null && _orderTypeTabController.index ==0){
        nAddress.id= value.data.address.id;
        nAddress.address= value.data.address.address;
        nAddress.city= value.data.address.city;
        nAddress.state= value.data.address.state;
        nAddress.zipcode= value.data.address.zipcode;
        address.clear();
        address.add(nAddress);
        try{
          List<Location> locations = await locationFromAddress(address.first.city+','+address.first.state);
          print(jsonEncode(locations));
          lat= locations.first.latitude.toString();
          lng= locations.first.longitude.toString();

        }catch (e){
          print(e);
          lat = "0";
          lng = "0";
          // EasyLoading.showToast('Invalid Address',
          //     toastPosition: EasyLoadingToastPosition.bottom);
          // return false;
        }
        _calculateShipping(lat,lng);

      }else
      {
        Navigator.push(
            context, MaterialPageRoute(
          builder: (context) => CheckOut(dateTime: dateTime,customerId:userId,instructions : instructions.text,
              shipping:shipping, userLoyalityPoints:userloayltyPoints,
              address: address,orderType : _orderTypeTabController.index),
        ));
      }

    }else{
      EasyLoading.showToast(value.message,
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
  bool _isValid() {
    switch (addType) {
      case AddCustomerType.DELIVERY:
        print(jsonEncode(address));
        String mobileNumber = mobileController.text.trim();
        if (mobileNumber.isEmpty) {
          EasyLoading.showToast('Mobile can\'t be empty',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        if (mobileNumber.length<10) {
          EasyLoading.showToast('Please Enter valid Mobile Number',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        if (nameController.text.isEmpty) {
          EasyLoading.showToast('Name can\'t be empty',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        if (emailController.text.isNotEmpty) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if(!regex.hasMatch(emailController.text)){
            EasyLoading.showToast('Email is not valid',
                toastPosition: EasyLoadingToastPosition.bottom);
            return false;
          }
          // return (!regex.hasMatch(dineemailController.text)) ? false : true;
        }
        if (address.first.city==null || address==null) {
          EasyLoading.showToast('Address can\'t be empty',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        if(dateTimeSlot!=null){
          if (dateTime==null) {
            EasyLoading.showToast('Select delivery slot date',
                toastPosition: EasyLoadingToastPosition.bottom);
            return false;
          }
        }
        return true;
        break;
      case AddCustomerType.PICKUP:
        String mobileNumber = pickmobileController.text.trim();
        if (mobileNumber.isEmpty) {
          EasyLoading.showToast('Mobile can\'t be empty',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        if (mobileNumber.length<10) {
          EasyLoading.showToast('Please Enter valid Mobile Number',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        if (pickemailController.text.isNotEmpty) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if(!regex.hasMatch(pickemailController.text)){
            EasyLoading.showToast('Email is not valid',
                toastPosition: EasyLoadingToastPosition.bottom);
            return false;
          }
          // return (!regex.hasMatch(dineemailController.text)) ? false : true;
        }
        if (picknameController.text.isEmpty) {
          EasyLoading.showToast('Name can\'t be empty',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        return true;
        break;
      case AddCustomerType.DINEIN:
        String mobileNumber = dinemobileController.text.trim();
        if (mobileNumber.isEmpty) {
          EasyLoading.showToast('Mobile can\'t be empty',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        if (mobileNumber.length<10) {
          EasyLoading.showToast('Please Enter valid Mobile Number',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        if (dineemailController.text.isNotEmpty) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if(!regex.hasMatch(dineemailController.text)){
            EasyLoading.showToast('Email is not valid',
                toastPosition: EasyLoadingToastPosition.bottom);
            return false;
          }
          // return (!regex.hasMatch(dineemailController.text)) ? false : true;
        }
        if (dinenameController.text.isEmpty) {
          EasyLoading.showToast('Name can\'t be empty',
              toastPosition: EasyLoadingToastPosition.bottom);
          return false;
        }
        return true;
        break;
    }

  }

  void _handleError(error) {
    EasyLoading.dismiss();
    if (error is CustomException) {
      EasyLoading.showToast(error.toString(),
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
  void _checkNumberOnNExt() async {
    switch (addType) {
      case AddCustomerType.DELIVERY:
        Map<String, dynamic> param = {
          "mobile": widget.phone!=null?widget.phone:mobileController.text,
        };
        EasyLoading.show(dismissOnTap: false);
        AppNetwork.getCustomerByPhone(param).then((value) => _handleNextResponse(value),
            onError: (error) => _handleError(error));
        break;
      case AddCustomerType.PICKUP:
        Map<String, dynamic> param = {
          "mobile":  widget.phone!=null?widget.phone:pickmobileController.text,
        };
        EasyLoading.show(dismissOnTap: false);
        AppNetwork.getCustomerByPhone(param).then((value) => _handleNextResponse(value),
            onError: (error) => _handleError(error));
        break;
      case AddCustomerType.DINEIN:
        Map<String, dynamic> param = {
          "mobile": widget.phone!=null?widget.phone: dinemobileController.text,
        };
        EasyLoading.show(dismissOnTap: false);
        AppNetwork.getCustomerByPhone(param).then((value) => _handleNextResponse(value),
            onError: (error) => _handleError(error));
        break;
    }
  }
  _handleNextResponse(CustomerData value) async {
    EasyLoading.dismiss();
    if (value.success) {
      switch (addType) {
        case AddCustomerType.DELIVERY:
          setState(()  {
            if (widget.phone != null) {
              mobileController.text = widget.phone;
            }
            nameController.text = value.data.fullName;
            fullName = value.data.fullName;
            emailController.text = value.data.email;
            loayltyPoints.text = value.data.loyalityPoints.toString();
            userloayltyPoints = value.data.loyalityPoints.toString();
            userId = value.data.id;
          });
          print(userId);
          if(value.data.customerAddress!=null){
            address =  value.data.customerAddress;
            print("add customer _calculateShipping");
            try{
              List<Location> locations = await locationFromAddress(address.first.city+','+address.first.state);
              print(jsonEncode(locations));
              lat= locations.first.latitude.toString();
              lng= locations.first.longitude.toString();
            }catch (e){
              print(e);
              lat = "0";
              lng = "0";
              // EasyLoading.showToast('Invalid Address',
              //     toastPosition: EasyLoadingToastPosition.bottom);
              // return false;
            }
            _calculateShipping(lat,lng);
          } else if(address!=null && address.first.city!=null){
            addAddress();
          }else{
            EasyLoading.showToast('Address can\'t be empty',
                toastPosition: EasyLoadingToastPosition.bottom);
            return false;
          }
          break;
        case AddCustomerType.PICKUP:
          setState(() {
            if(widget.phone!=null) {
              pickmobileController.text = widget.phone;
            }
            picknameController.text =  value.data.fullName;
            pickemailController.text =  value.data.email;
            pickloayltyPoints.text =  value.data.loyalityPoints.toString();
            userloayltyPoints =  value.data.loyalityPoints.toString();
            userId = value.data.id;
            print(userId);
          });
          if(userId==null){
            print("user id is null");
            return;
          }
          Navigator.push(
              context, MaterialPageRoute(
            builder: (context) => CheckOut(dateTime: dateTime,customerId:userId,instructions : instructions.text,
                shipping:shipping, userLoyalityPoints:userloayltyPoints,
                address: address,orderType : _orderTypeTabController.index),
          ));
          break;
        case AddCustomerType.DINEIN:
          setState(() {
            if(widget.phone!=null) {
              dinemobileController.text = widget.phone;
            }
            dinenameController.text =  value.data.fullName;
            dineemailController.text =  value.data.email;
            dineloayltyPoints.text =  value.data.loyalityPoints.toString();
            userloayltyPoints =  value.data.loyalityPoints.toString();
            userId = value.data.id;
            print(userId);
          });
          if(userId==null){
            print("user id is null");
            return;
          }
          Navigator.push(
              context, MaterialPageRoute(
            builder: (context) => CheckOut(dateTime: dateTime,customerId:userId,instructions : instructions.text,
                shipping:shipping, userLoyalityPoints:userloayltyPoints,
                address: address,orderType : _orderTypeTabController.index),
          ));
          break;
      }
    }else {
      addCustomer();
    }
  }

  void addAddress() {
    Map<String, dynamic> param = {
      "user_id": userId,
      "method": "add",
      "first_name": fullName,
      "mobile": mobileController.text,
      "address":address.first.address,
      "area_name": address.first.address,
      "area_id":"",
      "state": address.first.state,
      "city":address.first.city,
      "zipcode": address.first.zipcode,
      "address_id": "",
    };
    EasyLoading.show(dismissOnTap: false);
    AppNetwork.deliveryAddress(param)
        .then(_handleAddAddressResponse, onError: _handleError);
  }
  _handleAddAddressResponse(AddAddressResponse value) {
    EasyLoading.dismiss();
    if(value.success){
      _checkNumberOnNExt();
    }else{
      EasyLoading.showToast(value.message,
          toastPosition: EasyLoadingToastPosition.bottom);
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        Navigator.pop(context, false);
      });
    }
  }
  void _checkNumber() async {
    switch (addType) {
      case AddCustomerType.DELIVERY:
        Map<String, dynamic> param = {
          "mobile": widget.phone!=null?widget.phone:mobileController.text,
        };
        EasyLoading.show(dismissOnTap: false);
        AppNetwork.getCustomerByPhone(param).then((value) => _handleProductResponse(value),
            onError: (error) => _handleError(error));
        break;
      case AddCustomerType.PICKUP:
        Map<String, dynamic> param = {
          "mobile":  widget.phone!=null?widget.phone:pickmobileController.text,
        };
        EasyLoading.show(dismissOnTap: false);
        AppNetwork.getCustomerByPhone(param).then((value) => _handleProductResponse(value),
            onError: (error) => _handleError(error));
        break;
      case AddCustomerType.DINEIN:
        Map<String, dynamic> param = {
          "mobile": widget.phone!=null?widget.phone: dinemobileController.text,
        };
        EasyLoading.show(dismissOnTap: false);
        AppNetwork.getCustomerByPhone(param).then((value) => _handleProductResponse(value),
            onError: (error) => _handleError(error));
        break;
    }
  }
  _handleProductResponse(CustomerData value) {
    EasyLoading.dismiss();
    if (value.success) {
      switch (addType) {
        case AddCustomerType.DELIVERY:
          setState(() {
            if(widget.phone!=null) {
              mobileController.text = widget.phone;
            }
            nameController.text =  value.data.fullName;
            fullName =  value.data.fullName;
            emailController.text =  value.data.email;
            loayltyPoints.text =  value.data.loyalityPoints.toString();
            userloayltyPoints =  value.data.loyalityPoints.toString();
            userId = value.data.id;
            if(value.data.customerAddress!=null){
              address =  value.data.customerAddress;
              // lat = address.first.lat.toString();
              // lng = address.first.lng.toString();
              // _calculateShipping(lat,lng);
            }
          });
          break;
        case AddCustomerType.PICKUP:
          setState(() {
            if(widget.phone!=null) {
              pickmobileController.text = widget.phone;
            }
            picknameController.text =  value.data.fullName;
            pickemailController.text =  value.data.email;
            pickloayltyPoints.text =  value.data.loyalityPoints.toString();
            userloayltyPoints =  value.data.loyalityPoints.toString();
            userId = value.data.id;
          });

          break;
        case AddCustomerType.DINEIN:
          setState(() {
            if(widget.phone!=null) {
              dinemobileController.text = widget.phone;
            }
            dinenameController.text =  value.data.fullName;
            dineemailController.text =  value.data.email;
            dineloayltyPoints.text =  value.data.loyalityPoints.toString();
            userloayltyPoints =  value.data.loyalityPoints.toString();
            userId = value.data.id;
          });
          break;
      }
    }
    // else {
    //   addCustomer();
    // }
  }

  void _calculateShipping(String lat,String lng) async {
    if(lat==null && lng ==null){
      _checkNumberOnNExt();
    }
    Map<String, dynamic> param = {
      "storeLat": SharedPrefs.getStoreLatitude(),
      "storeLng":SharedPrefs.getStoreLongitude(),
      "userLat": lat,
      "userlng": lng,
    };
    AppNetwork.calculateShipping(param).then((value) => _handleCalculateResponse(value),
        onError: (error) => _handleError(error));
  }
  _handleCalculateResponse(CalculateShipping value) {
    // loading = false;
    if (value.success) {
      setState(() {
        shipping =  value.shipping;
      });
      if(userId==null){
        print("shipping--user id is null");
        return;
      }
      Navigator.push(
          context, MaterialPageRoute(
        builder: (context) => CheckOut(dateTime: dateTime, customerId:userId,instructions : instructions.text,
            shipping:shipping, userLoyalityPoints:userloayltyPoints,
            address: address,orderType : _orderTypeTabController.index),
      ));
    }else {
      EasyLoading.showToast(value.message,
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
}

enum AddCustomerType { PICKUP, DELIVERY, DINEIN }