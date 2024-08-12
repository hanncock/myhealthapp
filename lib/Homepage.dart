import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myhealth/addprescription.dart';
import 'package:myhealth/logins.dart';
import 'package:myhealth/profile.dart';
import 'package:myhealth/qrgen.dart';
import 'package:myhealth/reusbale.dart';
import 'package:myhealth/services.dart';
import 'package:myhealth/tests.dart';

import 'loader.dart';

class Homepage extends StatefulWidget {
  final List datas;
  const Homepage({super.key, required this.datas});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List prescriptions = [];
  List tests = [];
  AuthService auth = AuthService();
  bool loading = true;
  List profData = [];
  List nokdata = [];
  var ptnId;


  getPrescriptions()async{
    var resu = await auth.getMany("/api/hosi/prescription/list?patientId=${ptnId}");
    print(resu);
    setState(() {
      prescriptions = resu['data'];
      loading = false;
    });
  }

  getTests()async{
    var resu = await auth.getMany("/api/hosi/test/list?patientId=${ptnId}");
    print(resu);
    setState(() {
      tests = resu['data'];
      loading = false;
    });
  }

  getData()async{
    var resu ;
    Userdata[0]['type'] =='Medic' ? resu = await auth.getMany('/api/hosi/patient/list?id=${widget.datas[0]['id']}') :
    resu = await auth.getMany('/api/hosi/patient/list?name=${Userdata[0]['username']}');
    print(resu);
    setState((){
      profData = resu['data'];
      ptnId = resu['data'][0]['id'];
    });
  }

  nokdatas()async{

    var resu2 = await auth.getMany('/api/hosi/kin/list?patientId=${ptnId}');;
    print(resu2);
    setState((){
      nokdata = resu2['data'];
    });
  }

  @override
  void initState(){
    super.initState();

    getData().whenComplete((){
      getPrescriptions();
      getTests();
      nokdatas();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                       Userdata[0]['type'] =='Medic' ? Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text('Medical File for'),
                       ) :Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Welcome '),
                        ),
                        Userdata[0]['type'] =='Medic' ? SizedBox():Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${widget.datas[0]['username']== null ? widget.datas[0]['name'].toUpperCase() : widget.datas[0]['username'].toUpperCase()}'
                            ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),

                  Userdata[0]['type'] =='Patient' ?IconButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(data: profData,nokdata: nokdata,)));

                      },
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.person,color: Colors.blue,size: 30,),
                      )) :SizedBox(),

                  IconButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrGen(data: Userdata)));

                    },
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.qr_code,color: Colors.blue,size: 30,),
                    )),
                  IconButton(
                      onPressed: (){
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Recent Logins"),
                                      )
                                    ],
                                  ),
                                  Divider(thickness: 1,color: Colors.black12,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.circle,color: Colors.black,size: 15,),
                                        SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Text('${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',style: TextStyle(color: Colors.black45),),
                                            Text('${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}')
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrGen(data: Userdata)));
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => showModalBottomSheet(context: context,
                        //     builder: builder)));

                      },
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.receipt,color: Colors.blue,size: 30,),
                      ))
                ],
              ),
              Container(
                width: 400,
                height: 40,
                child: TabBar(
                    tabs: [
                  Text('Prescriptions'),
                  Text('Tests'),
                ]),
              ),
              Expanded(
                child: TabBarView(
                    children: [
                  Container(
                    child: Column(
                      children: [
                        Userdata[0]['type'] =='Medic' ? Row(
                          mainAxisAlignment:MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>  AddPrescription(ptndata: widget.datas,)
                                ).then((value) => getPrescriptions());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.blue
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Add Prescription',style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            )
                          ],
                        ): SizedBox(),
                        loading ? LoadingSpinCircle() : prescriptions.isEmpty? Text('No Prescriptions for patient') :Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: ListView.builder(
                              shrinkWrap:true,
                              itemCount: prescriptions.length,
                              itemBuilder: (context,index){
                                var prsc = prescriptions[index];
                                return Card(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.file_copy,color: Colors.blue,),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: [
                                                  Text('${prsc['dateissued']}',style: TextStyle(color: Colors.black45),),
                                                  InkWell(
                                                    onTap:(){
                                                      showDialog(context: context,
                                                          builder: (context) => Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                                                            child: Card(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: SizedBox(
                                                                  child: SingleChildScrollView(
                                                                    scrollDirection: Axis.vertical,
                                                                    child: Text('${prsc['description']}'),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      );
                                                    },
                                                    child: ConstrainedBox(
                                                      // maheight: 300,
                                                      // width:MediaQuery.of(context).size.width * 0.85,
                                                      constraints: BoxConstraints(
                                                        minHeight: 100,
                                                        maxHeight: 300,
                                                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text('${prsc['description']}',softWrap: true,),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Userdata[0]['type'] =='Medic' ?IconButton(
                                      //     onPressed: ()async{
                                      //       Map data ={
                                      //         "id":prsc['id'],
                                      //       };
                                      //       var resu = await auth.saveMany("/api/hosi/prescription/del", data);
                                      //       if(resu == 'success'){
                                      //         getPrescriptions();
                                      //         // Navigator.of(context).pop();
                                      //       }
                                      //     }, icon: Icon(Icons.delete,color: Colors.red,)):SizedBox()
                                    ],
                                  ),
                                );
                          }),
                        )
                      ],
                    ),
                  ),
                      Container(
                        child: Column(
                          children: [
                            Userdata[0]['type'] =='Medic' ? Row(
                              mainAxisAlignment:MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>  AddTest(ptndata: widget.datas,)
                                    ).then((value) => getTests());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.tips_and_updates),
                                          Text('Add Test',style: TextStyle(color: Colors.white),),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ): SizedBox(),
                            Container(
                              child: Column(
                                children: [
                                  loading ? LoadingSpinCircle() : tests.isEmpty? Text('No Tests for patient') :SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.74,
                                      child: ListView.builder(
                                          itemCount: tests.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context,indx){
                                            var tst = tests[indx];
                                            return Card(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Icon(Icons.schema,color: Colors.green,),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('${tst['dateissued']}',style: TextStyle(color: Colors.black45),),
                                                            ConstrainedBox(
                                                              constraints: BoxConstraints(
                                                                  minHeight: 100,
                                                                  maxHeight: 300
                                                              ),
                                                              child: InkWell(
                                                                onTap:(){
                                                                  showDialog(context: context,
                                                                      builder: (context) => Padding(
                                                                        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                                                                        child: Card(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: SizedBox(
                                                                              child: SingleChildScrollView(
                                                                                scrollDirection: Axis.vertical,
                                                                                child: Text('${tst['test']}'),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                  );
                                                                },
                                                                child: SizedBox(
                                                                  height:300,
                                                                  width:MediaQuery.of(context).size.width * 0.85,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text('${tst['test']}',softWrap: true,),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Userdata[0]['type'] =='Medic' ?IconButton(
                                                  //     onPressed: ()async{
                                                  //       Map data ={
                                                  //         "id":tst['id'],
                                                  //       };
                                                  //       var resu = await auth.saveMany("/api/hosi/test/del", data);
                                                  //       if(resu == 'success'){
                                                  //         getTests();
                                                  //         // Navigator.of(context).pop();
                                                  //       }
                                                  // }, icon: Icon(Icons.delete,color: Colors.red,)):SizedBox()

                                                ],
                                              ),
                                            );

                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                ]),
              )
            ],
          )),
    );
  }
}
