import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:myhealth/logins.dart';
import 'package:myhealth/services.dart';

import 'loader.dart';

class Profile extends StatefulWidget {
  final List?  data;
  final List?  nokdata;
  const Profile({super.key, this.data, this.nokdata});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  var phone;
  var id;
  var email;
  var name;
  var location;
  var type;
  bool showpassword = false;
  bool loading = false;
  var password;
  List drops = ["Patient","Medic"];
  List relation = ["Mother","Father","Siblings","Uncle","etc"];
  AuthService auth = AuthService();

  TextEditingController names = new TextEditingController();
  var kinId;
  TextEditingController phoneNo = new TextEditingController();
  var selrelation;
  var patientId;
  List relationdata = [];

  // List profData = [];

  // getData()async{
  //   var resu = await auth.getMany('/api/hosi/patient/list?name=${widget.data![0]['username']}');
  //   print(resu);
  //   setState((){
  //     profData = resu['data'];
  //   });
  // }

  loaddefs(){
    id =widget.data == null? null :widget.data![0]['id'];
    name =widget.data == null? null :widget.data![0]['name'];
    location =widget.data == null? null :widget.data![0]['location'];
    email = widget.data == null? null :widget.data![0]['email'];
    phone = widget.data == null? null :widget.data![0]['phone'];
    relationdata = widget.nokdata == null? [] :widget.nokdata!;
  }





  @override
  void initState(){
    super.initState();
    // getData();
    loaddefs();
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Profile'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              width: 400,
              height: 60,
              child: TabBar(
                tabs: [
                  Text('User Profile'),
                  Text('Next Of Kin')
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text('${widget.data}'),
                      SizedBox(),
                      showpassword ? SizedBox():Form(
                        child: Column(
                          children:[
                            Container(
                              width: 380,
                              child: TextFormField(
                                initialValue: widget.data == null? '' :widget.data![0]['name'] ,
                                readOnly: widget.data == null  ? false : true,
                                onChanged: (val){
                                  setState(() {
                                    name = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Name',
              
                                ),
                              ),
                            ),
                            SizedBox(height: 40,),
                            Container(
                              width: 380,
                              child: TextFormField(
                                initialValue: widget.data == null? '' :widget.data![0]['location'] ,
                                readOnly: widget.data == null  ? false : true,
                                onChanged: (val){
                                  setState(() {
                                    location = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Location',
              
                                ),
                              ),
                            ),
                            SizedBox(height: 40,),
                            Container(
                              width: 380,
                              child: TextFormField(
                                initialValue: widget.data == null? '' :widget.data![0]['phone'] ,
                                // readOnly: widget.data == null  ? false : true,
                                onChanged: (val){
                                  setState(() {
                                    phone = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Phone Number',
              
                                ),
                              ),
                            ),
                            SizedBox(height: 40,),
                            Container(
                              width: 380,
                              child: TextFormField(
                                initialValue: widget.data == null? '' :widget.data![0]['email'] ,
                                readOnly: widget.data == null  ? false : true,
                                onChanged: (val){
                                  setState(() {
                                    email = val;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'email',
              
                                ),
                              ),
                            ),
                            SizedBox(height: 40,),
              
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                        color: Colors.red.withOpacity(0.1),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30),
                                          child: Text('Cancel',style: TextStyle(color: Colors.red),),
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: ()async{
                                      setState((){
                                        loading = true;
                                      });
                                      Map data ={
                                        "id":  id ,
                                        "name": name,
                                        "phone": "${phone}",
                                        "location": "${location}",
                                        "email": "${email}",
                                      };
                                      print(data);
                                      loading ? showDialog(
                                          context: context, builder: (_) => const LoadingSpinCircle()
                                      ): null;
                                      var resu = await auth.saveMany("/api/hosi/patient/add", data);
                                      if(resu == 'success'){
                                        setState((){
                                          showpassword = true;
                                          loading = false;
                                        });
                                        widget.data == null ? null :
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Logins()));
                                          // Navigator.of(context).pop();
                                          // Navigator.of(context).pop();
              
                                      }
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.green
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30),
                                          child: Text('Save',style: TextStyle(color: Colors.white),),
                                        )),
                                  )
                                ],
                              ),
                            )
                          ]
                        ),
                      ),
                      widget.data == null ? showpassword ?Column(
                        children:[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('Username'),
                                SizedBox(width :20),
                                Container(
                                  width:300,
                                  decoration:BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width:1)
                                  ),
                                  child:Center(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${name}'),
                                  )),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height:20),
                          Container(
                            width: 380,
                            child: TextFormField(
                              // minLines: 2,
                              // maxLines: 2,
                              onChanged: (val){
                                setState(() {
                                  password = val;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
              
                              ),
                            ),
                          ),
                          SizedBox(height:20),
                          Container(
                            width: 380,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width:1)
                            ),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: type,
                                  items: drops.map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${e}'),
                                      ))).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      type = value;
              
                                    });
              
                                  },
                                )),
                          ),
                          SizedBox(height:20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                      color: Colors.red.withOpacity(0.1),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30),
                                        child: Text('Cancel',style: TextStyle(color: Colors.red),),
                                      )),
                                ),
                                GestureDetector(
                                  onTap: ()async{
                                    loading ? showDialog(
                                        context: context, builder: (_) => const LoadingSpinCircle()
                                    ): null;
                                    Map data ={
                                      "id": null,
                                      "username": name,
                                      "password": "${password}",
                                      "type": "${type}",
                                    };
                                    var resu = await auth.saveMany("/api/hosi/creds/add", data);
                                    if(resu == 'success'){
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.green
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30),
                                        child: Text('Save',style: TextStyle(color: Colors.white),),
                                      )),
                                )
                              ],
                            ),
                          )
                        ]
                      ) : SizedBox() : SizedBox(),
              
                    ],
                  ),
                  Userdata[0]['type'] !='Patient'? SizedBox() :Column(
                    children: [
                      SizedBox(height: 30,),
                      Container(
                        width: 380,
                        child: TextFormField(
                          controller: names,
                          // initialValue: names,
                          // initialValue: widget.data == null? '' :widget.data![0]['email'] ,
                          // readOnly: widget.data == null  ? false : true,
                          onChanged: (val){
                            setState(() {
                              names.text = val;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Names',

                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        width: 380,
                        child: TextFormField(
                          controller: phoneNo,
                          // initialValue: phoneNo ,
                          // readOnly: widget.data == null  ? false : true,
                          onChanged: (val){
                            setState(() {
                              phoneNo.text = val;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone No',

                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        width: 380,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width:1)
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selrelation,
                              items: relation.map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${e}'),
                                  ))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selrelation = value;

                                });

                              },
                            )),
                      ),
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  color: Colors.red.withOpacity(0.1),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30),
                                    child: Text('Cancel',style: TextStyle(color: Colors.red),),
                                  )),
                            ),
                            GestureDetector(
                              onTap: ()async{
                                setState((){
                                  loading = true;
                                });
                                Map data ={
                                  "id": kinId,
                                  "patientId": id,
                                  "names": names.text,
                                  "phoneNo": phoneNo.text,
                                  "relation": "${selrelation}",
                                };
                                print(data);
                                loading ? showDialog(
                                    context: context, builder: (_) => const LoadingSpinCircle()
                                ): null;
                                var resu = await auth.saveMany("/api/hosi/kin/add", data);
                                if(resu == 'success'){
                                  var resu2 = await auth.getMany('/api/hosi/kin/list?patientId=${id}');
                                  setState((){
                                    relationdata = resu2['data'];
                                    loading = false;
                                    Navigator.of(context).pop();
                                  });
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 30),
                                    child: Text('Save',style: TextStyle(color: Colors.white),),
                                  )),
                            ),

                          ],
                        ),
                      ),
                      Divider(thickness: 1,),
                      relationdata == null ? Text('Add Next Of Kin In the form above') :SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                          // color: Colors.red,
                          height: 350,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: relationdata.length,
                              itemBuilder: (context,index){
                                var nok = relationdata[index];
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      names.text = relationdata[index]['names'];
                                      patientId = relationdata[index]['patientId'];
                                      phoneNo.text = relationdata[index]['phoneNo'];
                                      selrelation = relationdata[index]['relation'];
                                      kinId = relationdata[index]['id'];
                                    });
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.people),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text('${nok['names'].toUpperCase()}'),
                                                          ),
                                                          SizedBox(width: 20,),
                                                          Text('${nok['relation']}',style: TextStyle(color: Colors.black45),)
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.call),
                                                          SizedBox(width:20),
                                                          Text('${nok['phoneNo']}'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                    onTap:()async{
                                                      Map data = {
                                                        "id": relationdata[index]['id'],
                                                      };
                                                      var resu = await auth.saveMany("/api/hosi/kin/del", data);
                                                      if(resu == 'success'){

                                                          var resu2 = await auth.getMany('/api/hosi/kin/list?patientId=${patientId}');;
                                                          print(resu2);
                                                          setState((){
                                                            relationdata = resu2['data'];
                                                          });
                                                        // Navigator.of(context).pop();
                                                      }
                                                    },
                                                    child: Icon(Icons.delete,color: Colors.red,)
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                          }),
                        ),
                      )

                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
