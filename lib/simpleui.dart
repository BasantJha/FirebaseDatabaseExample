import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lastfirebasedatabase/Datacard.dart';
import 'package:lastfirebasedatabase/responsive.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SharedPreference(title: 'Flutter Demo Home Page'),
    );
  }
}


class SharedPreference extends StatefulWidget {
  const SharedPreference({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<SharedPreference> createState() => _SharedPreferenceState();
}


class _SharedPreferenceState extends State<SharedPreference> {

  static final CollectionReference _productss = FirebaseFirestore.instance.collection('products');

  TextEditingController idcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController empnamecontroller = TextEditingController();
  TextEditingController addcontroller = TextEditingController();
  TextEditingController contactcontroller = TextEditingController();


  final _form = GlobalKey<FormState>();
  final _form1 = GlobalKey<FormState>();
  bool _isValid = false;
  String? contact;
  List allsavedcontact = [];
  List allsavedname = [];
  List allsavedUniqueId = [];
  late int index;
  late  int Id;

  late final Map<String,dynamic> map= {};

  @override
  void initState() {
    super.initState();
    getData();
    index = allsavedname.length + 1;
    assignId();
  }

  assignId() async{
    var list = [];
    QuerySnapshot querySnapshot = await _productss.get();
    querySnapshot.docs.forEach((element) {
      list.add(element.id);
    });
    setState(() {
      allsavedUniqueId = list;
    });
    print("uniqueId $allsavedUniqueId");
    print("UniqueId value dataType ${allsavedUniqueId[0].runtimeType}");
    print("Data present ? ${allsavedUniqueId.contains(6.toString())}");
  }

  //For EmailField Form
  void _saveForm() {
    setState(() {
      _isValid = _form.currentState!.validate();
    });
    print("function called");
  }

  //Get Saved Contact Deatils
  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _productss.get();
    allsavedcontact = querySnapshot.docs.map((doc) => doc.get('contact')).toList();
    allsavedname = querySnapshot.docs.map((doc) => doc.get('name')).toList();
    Id = allsavedname.length+1;
    print("Indide getdata ${allsavedUniqueId}");
  }



   //Update Method
  static Future<void> update(Id,email,name,address,contact) async{
    print("Id : ${Id}");
    print("Address ${address}");
    print("Email ${email}");
    print("Contact ${contact}");
    print("name ${name}");
    await _productss
        .doc(Id)
        .update({
      "address": address,
      "contact": contact,
      "email": email,
      "name": name,
    });
  }


  // Mobile Valodation
  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if(value.length != 10){
      return "Mobile number must 10 digits";
    }else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return "valid";
  }

  //Ui for Both Mobile and web
  SingleChildScrollView MainfunctionUi(){
    //print("Inside singlechilscroll $allsavedUniqueId");
    return SingleChildScrollView(
        child: Card(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [

                  //Id Field
                  Row(
                    children:  [
                      Expanded(
                          flex: 1,
                          child: Text("Enter Id")
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: idcontroller,
                            decoration:  InputDecoration(
                                border: OutlineInputBorder()),
                            onChanged: (value){
                              print(value);
                              print(idcontroller.text.runtimeType);
                            },
                          ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //Email Row Field
                  Row(
                    children:  [
                      Expanded(
                          flex: 1,
                          child: Text("Email Field")
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Form(
                          key: _form,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            decoration:  InputDecoration(
                                border: OutlineInputBorder()),
                          ),
                        )
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //EmpName Row Field
                  Row(
                    children:  [
                      Expanded(
                          flex: 1,
                          child: Text("Emp Name")
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: empnamecontroller,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'), allow: true)
                          ],
                          decoration:  InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Address Field Row
                  Row(
                    children:  [
                      Expanded(
                          flex: 1,
                          child: Text("Address")
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: addcontroller,
                          decoration:  InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Contact Number Field Row
                  Row(
                    children:  [
                      Expanded(
                          flex: 1,
                          child: Text("Contact Number")
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Form(
                          key: _form1,
                          child: TextFormField(
                            controller: contactcontroller,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration:  InputDecoration(
                              border: OutlineInputBorder(),
                              counter: Offstage(),
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //Insert User Details in Firestore
                  ElevatedButton(
                    child: Text('Insert User Details'),
                    onPressed: () async{
                      assignId();
                      _saveForm();
                      getData();

                      print("above controller ${allsavedUniqueId}");

                      if(idcontroller.text == null || idcontroller.text == ""){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Enter Id')));
                      }

                      //int.parse(idcontroller.text



                      else if(!_isValid){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Enter Valid Email')));
                      }

                      else if(!empnamecontroller.text.toString().contains(RegExp(r'[A-Za-z]'))){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Enter Valid Name')));
                      }


                      else if(addcontroller.text == null || addcontroller.text == ""){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Enter Address')));
                      }


                      else if(contactcontroller.text == null || contactcontroller.text == "" ){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Enter Contact')));
                      }


                      else if(!isValidPhoneNumber(contactcontroller.text)){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Enter Valid Contact')));
                      }


                      else if(allsavedcontact.contains(contactcontroller.text)){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Contact already Exists')));
                      }


                      else if(allsavedUniqueId.contains(idcontroller.text)){
                        print("UniqueId checked");
                        update(idcontroller.text,emailcontroller.text,empnamecontroller.text,addcontroller.text,contactcontroller.text);
                      }


                      else{
                        String email = emailcontroller.text.toString();
                        String name = empnamecontroller.text;
                        String address = addcontroller.text;
                        if(contactcontroller.text == null || contactcontroller.text == "" ){
                          contact = '0';
                          print(contact);
                          map.addAll({
                            "email": email,
                            "name": name,
                            "address": address,
                            "contact": contact
                          });
                          // setState(() {
                          //   Id = Id+1;
                          // });
                        }else{
                          contact = contactcontroller.text;
                          print(contact);
                          map.addAll({
                            "email": email,
                            "name": name,
                            "address": address,
                            "contact": contact
                          });
                          // setState(() {
                          //   Id = Id+1;
                          // });
                        }


                        // print("all unique id inside controller ${allsavedUniqueId}");
                        // print("status id present? ${allsavedUniqueId.contains(idcontroller.text)}");


                        _productss.doc(idcontroller.text.toString()).set(map);

                        // QuerySnapshot querySnapshot = await _productss.get();
                        // querySnapshot.docs.map((doc) {
                        //   doc.get('name');
                        //   print("Id: ${doc.id}");
                        // });


                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Details entered Successfully')));
                      }


                      // for( var i = 0; i<map.length;i++){
                      //   String key = map.keys.elementAt(i);
                      //   var value = map.values.elementAt(i);
                      //   print(" Value ${value}");
                      //   _productss.add({
                      //   key: map['$key'],
                      //   });
                      // }
                      print(empnamecontroller.text.toString());

                    },
                  ),


                  SizedBox(
                    height: 10,
                  ),


                  //Go To See The All Saved Users Details
                  ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,MaterialPageRoute(builder: (_)=> Responsive(
                          mobile: DataCard(),
                          tablet: Center(
                            child: Container(
                              width: 400,
                              child: DataCard(),
                            ),
                          ),
                          desktop: Center(
                            child: Container(
                              width: 400,
                              child: DataCard(),
                            ),
                          ),
                        ),

                        ),
                        );
                      },
                      child: Text("Go To Save details")
                  ),

                ],
              ),
            )
        )
    );
  }

  //Build Main Function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Responsive(
        mobile: MainfunctionUi(),
        tablet: Center(
          child: Container(
            width: 400,
            child: MainfunctionUi(),
          ),
        ),
        desktop: Center(
          child: Container(
            width: 400,
            child: MainfunctionUi(),
          ),
        ),
      ),
    );
  }


  // Check Wether the number is valid or Not
  bool isValidPhoneNumber(String string) {
    // Null or empty string is invalid phone number
    if (string == null || string.isEmpty) {
      return false;
    }
    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v
    const pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }


}

