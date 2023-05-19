import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lastfirebasedatabase/responsive.dart';

class  DataCard extends StatefulWidget {
  DataCard({
    Key? key,
  }) : super(key: key);
 // List<User> data = [];
  @override
  DataCardState createState() =>  DataCardState();
}

class  DataCardState extends State<DataCard> {
  static final CollectionReference _productss =
  FirebaseFirestore.instance.collection('products');
  bool refresh = false;
 static late  DocumentSnapshot documentSnapshot2;
  static TextEditingController emailupdate = TextEditingController();
  static TextEditingController empnameupdate = TextEditingController();
 static TextEditingController addressupdate = TextEditingController();
  static TextEditingController contactupdate = TextEditingController();
  List allData = [];

  //UI for Web and Mobile
  Container MainfunctionUi(){
    return Container(
      child: StreamBuilder(
          stream: _productss.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if(streamSnapshot.hasData){
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                 late final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                  return Card(
                      margin:EdgeInsets.all(20),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                        itemCount: data.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context, int index) {
                                          String key = data.keys.elementAt(index);
                                          var val = data.values.elementAt(index);
                                          return ListTile(
                                              title:
                                              Padding(
                                                padding: EdgeInsets.only(top: 10,left: 5),
                                                child: Container(
                                                  child: Text("$key",
                                                    style: TextStyle(
                                                        // fontWeight: Projectconst.normal_FontWeight,
                                                        // fontFamily: Projectconst.fontfamily,
                                                        // fontSize: Projectconst.large_FontSize,
                                                        color: Color(0xff000000)
                                                    ),
                                                  ),
                                                ),
                                              ) ,
                                              subtitle: Text(
                                                "$val"
                                              )
                                          );
                                        }),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       flex:1,
                                    //       child: Text("email"),
                                    //     ),
                                    //     Expanded(
                                    //       flex: 1,
                                    //       child: Text(documentSnapshot['email'].toString()),
                                    //     )
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       flex:1,
                                    //       child: Text("Name"),
                                    //     ),
                                    //     Expanded(
                                    //       flex: 1,
                                    //       child: Text(documentSnapshot['name'].toString()),
                                    //     )
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       flex:1,
                                    //       child: Text("Address"),
                                    //     ),
                                    //     Expanded(
                                    //       flex: 1,
                                    //       child: Text(documentSnapshot['address'].toString()),
                                    //     )
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       flex:1,
                                    //       child: Text("Contact"),
                                    //     ),
                                    //     Expanded(
                                    //         flex: 1,
                                    //         child: Text(documentSnapshot['contact'].toString())
                                    //     )
                                    //   ],
                                    // ),
                                  ],
                                )
                            ),

                            SizedBox(
                              width: 60,
                            ),

                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: ElevatedButton(
                                      onPressed: (){
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: Text('Do You want To Delete'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false), // passing false
                                                    child: Text('cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _deleteProduct(documentSnapshot.id);
                                                      // _queryAll();
                                                      Navigator.pop(context, false);
                                                    },
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            }).then((exit) {
                                          if (exit == null) return;

                                          if (exit) {
                                            // user pressed Yes button
                                          } else {
                                            // user pressed No button
                                          }
                                        });
                                      },
                                      child: Text("Delete")
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () async{
                                      setState(() {
                                        documentSnapshot2 = documentSnapshot;
                                      });
                                      showDialog(context: context, builder: (BuildContext context) => Responsive(
                                        mobile: errorDialog(context),
                                        tablet: Center(
                                          child: Container(
                                            width: 400,
                                            child: errorDialog(context),
                                          ),
                                        ),
                                        desktop: Center(
                                          child: Container(
                                            width: 400,
                                            child: errorDialog(context),
                                          ),
                                        ),
                                      )
                                      );
                                    },
                                    child: Text("Edit"),
                                  ),


                                // SizedBox(
                                //   height: 10,
                                // ),
                                // ElevatedButton(
                                //     onPressed: (){
                                //      getData();
                                //     },
                                //     child: Text("Print List")
                                // )


                              ],
                            )
                          ],
                        ),
                      )
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      )
    );
  }

  //Get All the saved Details
  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _productss.get();
     allData = querySnapshot.docs.map((doc) => doc.get('contact')).toList();
     print(allData);
  }

  // Build main Function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show table"),
      ),
      body:Responsive(
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
      )
    );
  }

  //Delete Function
  Future<void> _deleteProduct(String productId) async {
    await _productss.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  // Update Function
 static Future<void> update(documentSnapshot,key,fieldvalue) async{
    await _productss
        .doc(documentSnapshot!.id)
        .update({
         key:fieldvalue
        });
  }


  //Update Dialog Function
   Dialog errorDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          height: 350,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [

                  /*
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
                        child: TextField(
                          controller: emailupdate,
                          decoration:  InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                          controller: empnameupdate,
                          keyboardType: TextInputType.number,
                          decoration:  InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                        child: TextFormField(
                          controller: addressupdate,
                          decoration:  InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                        child: TextField(
                          controller: contactupdate,
                          decoration:  InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  */
                  Row(
                    children:  [
                      Expanded(
                          flex: 1,
                          child: Text("Key Filed")
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: emailupdate,
                          decoration:  InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ),


                  Row(
                    children:  [
                      Expanded(
                          flex: 1,
                          child: Text("Filed Value")
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: empnameupdate,
                          decoration:  InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                      )
                    ],
                  ),

                  ElevatedButton(
                      onPressed: () {
                        update(
                              documentSnapshot2,
                              emailupdate.text.toString(),
                              empnameupdate.text.toString()
                        );
                        Navigator.pop(context, false);
                      },
                      child: Text("Update")
                  )
                ],
              ),
            ),
          ),
        )
    );
   }


  // if (datasnapshot.data.containsValue("nova")) {
  // setState(() {
  // myText5 = "value exists";
  // });
  // } else if (!datasnapshot.data.containsValue("nova")) {
  // setState(() {
  // myText6 = "value not exists";
  // });
}
