import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_flutter_test/Components/MainAppButton.dart';
import 'package:new_flutter_test/Components/MainDialog.dart';
import 'package:new_flutter_test/Components/MainTextField.dart';
import 'package:new_flutter_test/Constants/AppTextStyle.dart';
import 'package:new_flutter_test/Constants/ColorConstants.dart';
import 'package:new_flutter_test/Helpers/Database.dart';
import 'package:new_flutter_test/Models/UserModel.dart';
import 'package:new_flutter_test/Providers/LocationProvider.dart';
import 'package:path/path.dart' as syspaths;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';
import 'package:url_launcher/url_launcher.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isLoading = false;
  bool isUploaded = false;
  bool isPickedUp = false;

  var IMEIController = TextEditingController();
  var FNameController = TextEditingController();
  var LNameController = TextEditingController();
  var passportController = TextEditingController();
  var emailController = TextEditingController();

  Map<String, dynamic> dataMap = {
    "IMEI": 0,
    "first_name": "",
    "last_name": "",
    "doB": "",
    "passport": 0,
    "email": "",
    "picture": "",
    "lat": "",
    "lng": "",
  };

  DateTime selectedDate = DateTime.now().subtract(Duration(days: 6570));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1920, 8),
        lastDate: DateTime(2016));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dataMap["doB"] =
            DateFormat('dd-MM-yyyy').format(selectedDate).toString();
        isPickedUp = true;
      });
      print(selectedDate);
      print(isPickedUp);
    }
  }

  final _formKey = GlobalKey<FormState>();

  File _image;
  final picker = ImagePicker();

  Future<void> _takePicture() async {
    final pickedFile = await picker.getImage(source:Platform.isAndroid ? ImageSource.camera:ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        isUploaded = true;
      } else {
        print('No image selected.');
      }
    });
    final  appDir = await getApplicationDocumentsDirectory();
    var fileName = syspaths.basename( appDir.path);
    final File localImage = await _image.copy('${appDir.path}/$fileName');
    dataMap["picture"] = localImage.path.toString();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/menu.png",
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                      "Home",
                                  style: AppTextStyle.regularTitle20
                                      .copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, "/home");
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 20,
                      ),
                      Text(
                        "Fill The Form `Below to Be Customer of \n"
                        "Mobile-technologies",
                        style: AppTextStyle.regularTitle18
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MainTextField(
                        onChanged: (text) {
                          dataMap["IMEI"] = text;
                        },
                        validator: (text) {
                          if (text.length < 4) {
                            return "IMEI not valid";
                          } else {
                            return null;
                          }
                        },
                        iconData: Icons.qr_code_scanner_outlined,
                        hint: "IMEI",
                        controller: IMEIController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 12),
                          width: double.infinity,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.info_outline,
                                color: Color(0xFF666666),
                                size: 16,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Our  IMEI  is Auto Populated !",
                                style: AppTextStyle.thinTitle12,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              onChanged: (text) {
                                dataMap["first_name"] = text;
                              },
                              validator: (text) {
                                if (text.length < 4) {
                                  return "First Name not valid";
                                } else {
                                  return null;
                                }
                              },
                              controller: FNameController,
                              showCursor: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF2F3F5),
                                hintStyle: AppTextStyle.regularTitle14,
                                hintText: "First Name",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              onChanged: (text) {
                                dataMap["last_name"] = text;
                              },
                              validator: (text) {
                                if (text.length < 4) {
                                  return "Last Name not valid";
                                } else {
                                  return null;
                                }
                              },
                              controller: LNameController,
                              showCursor: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF2F3F5),
                                hintStyle: AppTextStyle.regularTitle14,
                                hintText: "Last Name",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MainTextField(
                        onChanged: (text) {
                          dataMap["passport"] = text;
                        },
                        validator: (text) {
                          if (text.length < 6) {
                            return "Passport not valid";
                          } else {
                            return null;
                          }
                        },
                        iconData: Icons.person_pin_rounded,
                        hint: "Passport",
                        controller: passportController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MainTextField(
                        onChanged: (text) {
                          dataMap["email"] = text;
                        },
                        validator: (text) {
                          if (text.length < 6) {
                            return "Email not valid";
                          } else {
                            return null;
                          }
                        },
                        iconData: Icons.email_rounded,
                        hint: "Email",
                        controller: emailController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => _takePicture(),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isUploaded
                                  ? Icon(
                                      Icons.done,
                                      color: PaletteColors.mainAppColor,
                                    )
                                  : SizedBox.shrink(),
                              Row(
                                children: [
                                  isUploaded
                                      ? Row(
                                          children: [
                                            Text(
                                              "(",
                                              style: AppTextStyle.thinTitle14,
                                              textAlign: TextAlign.left,
                                            ),
                                            Image.file(
                                              _image,
                                              height: 20,
                                            ),
                                            Text(
                                              ")",
                                              style: AppTextStyle.thinTitle14,
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Upload a Picture ",
                                    style: AppTextStyle.regularTitle14
                                        .copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Image.asset(
                                    "assets/images/upload.png",
                                    height: 20,
                                    color: PaletteColors.blackAppColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isPickedUp
                                ? Icon(
                                    Icons.done,
                                    color: PaletteColors.mainAppColor,
                                  )
                                : SizedBox.shrink(),
                            InkWell(
                              onTap: () async {
                                await _selectDate(context);
                              },
                              child: Row(
                                children: [
                                  isPickedUp
                                      ? Text(
                                          "(${DateFormat('dd-MM-yyyy').format(selectedDate)})",
                                          style: AppTextStyle.thinTitle14,
                                          textAlign: TextAlign.left,
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "Date of Birth ",
                                    style: AppTextStyle.regularTitle14
                                        .copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Image.asset(
                                    "assets/images/date.png",
                                    height: 20,
                                    color: PaletteColors.blackAppColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MainAppButton(
                        label: "save",
                        onPressed: onSubmit,
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Have you a problem? ",
                              style: AppTextStyle.thinTitle12,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _launchURL(url:"https://www.mobile-technologies.com");
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                "Help Center",
                                style: AppTextStyle.boldTitle18
                                    .copyWith(color: PaletteColors.mainAppColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    String deviceName="";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName="Android : ${androidInfo.model.toString()}";
    }else if (Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName="IOS : ${iosInfo.model.toString()}";
    }else{
      deviceName="Nor Android & Nor IOS";
    }

    var loc = Provider.of<LocationProvider>(context,listen: false);
    dataMap["lat"] = loc.latitude;
    dataMap["lng"] = loc.longitude;


    if (!isUploaded) {
      showMainDialog(
          context: context,
          label: "Warning !",
          content: "Your picture is Missing ! \n Please Upload a picture ");
    } else if (!isPickedUp) {
      showMainDialog(
          context: context,
          label: "Warning !",
          content: "Your Date Of Birth is Missing ! \n PleaseSelect a Date ");
    } else {
      if (selectedDate
          .isBefore(DateTime.now().subtract(Duration(days: 6575)))) {
        try {
          DBProvider.db.newUser(User(
              IMEI: int.parse(dataMap["IMEI"]),
              firstName: dataMap["first_name"],
              lastName: dataMap["last_name"],
              doB: dataMap["doB"],
              passport: int.parse(dataMap["passport"]),
              email: dataMap["email"],
              picture: dataMap["picture"].toString(),
              deviceName: "deviceName",
              lat: dataMap["lat"],
              lng: dataMap["lat"]));

          setState(() {
            IMEIController.clear();
            FNameController.clear();
            LNameController.clear();
            emailController.clear();
            passportController.clear();
            isUploaded = false;
            isPickedUp = false;
          });
          showMainDialog(
              context: context,
              label: "Congrats !",
              content: "Registration Success! \n Thank you");
          Timer(Duration(seconds: 2), () {
            Navigator.pushNamed(context, "/home");
          });
        } catch (err) {
          showMainDialog(
              context: context,
              label: "Warning !",
              content: "Registration failed! \n Try Input Valid Information");
        }
      } else {
        showMainDialog(
            context: context,
            label: "You are -18 !",
            content: "You are below 18 years old ! \n Sorry come back later ");
      }
    }
  }

  _launchURL({String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
