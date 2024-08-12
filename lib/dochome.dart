import 'package:flutter/material.dart';
import 'package:myhealth/Homepage.dart';
import 'package:myhealth/loader.dart';
import 'package:myhealth/qrgen.dart';
import 'package:myhealth/services.dart';

class DocHome extends StatefulWidget {
  final List data;
  const DocHome({super.key,required this.data});

  @override
  State<DocHome> createState() => _DocHomeState();
}

class _DocHomeState extends State<DocHome> {

  AuthService auth = AuthService();
  List patients = [];
  bool loading = true;

  getPatients()async{
    var resu = await auth.getMany('/api/hosi/patient/list');
    print(resu);
    setState(() {
      patients = resu['data'];
      loading = false;
    });
  }

  genQrfiles(details){
    var name = details['name'];
    var phone = details['phone'];
    // var mail = details[mail]
    return "Name : ${name},phone:$phone";
  }

  @override
  void initState(){
    super.initState();
    getPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Patient Lists'),
              ),
            ],
          ),
          loading ? LoadingSpinCircle() : patients.isEmpty? Text('No patients') :ListView.builder(
            shrinkWrap: true,
              itemCount: patients.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onDoubleTap:(){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrGen(data: [patients[index]])));
                    },
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(datas: [patients[index]])));
                  },
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${patients[index]['name'][0].toUpperCase()}',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                            ),
                          ),

                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('${patients[index]['name'].toUpperCase()}',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text('${patients[index]['phone']}',style: TextStyle(color: Colors.black),),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
          }),
          // QrImageView(
          //     data: 'welcome all',
          //   version: QrVersions.auto,
          //   gapless: false,
          //   size: 320,
          // )
        ],
      ),
    );
  }
}
