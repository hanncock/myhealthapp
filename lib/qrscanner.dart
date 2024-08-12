import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:myhealth/AES.dart';
import 'package:myhealth/services.dart';

import 'Homepage.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {

  AESEncryption enc = AESEncryption();
  var qrData ;
  var ptndata = [];
  List kin = [];
  AuthService auth = AuthService();

  // bool loading = false;

  getNamefromId(id)async{
    var resu = await auth.getMany('/api/hosi/creds/list?id=${id}');
    print(resu);
    getPatients(resu['data'][0]['username'].toString());
  }

  getPatients(id)async{
    // var resu = await auth.getMany('/api/hosi/patient/list?id=${id}');
    var resu = await auth.getMany('/api/hosi/patient/list?name=${id}');
    print(resu);
    setState(() {
      ptndata = resu['data'];
      // loading = false;
    });
    getPatientsKin(resu['data'][0]['id']);
  }

  getPatientsKin(id)async{
    var resu = await auth.getMany('/api/hosi/kin/list?patientId=${id}');
    print('kin data');
    print(resu);
    setState(() {
      kin = resu['data'];
      // loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(datas: ptndata)));
              },
              child: ptndata.isEmpty ? Text('') :  Card(
                elevation: 1,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${ptndata[0]['name'][0].toUpperCase()}',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text('${ptndata[0]['name'].toUpperCase()}',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text('${ptndata[0]['phone']}',style: TextStyle(color: Colors.black),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0,top: 8),
                                    child: Text('${ptndata[0]['email']}',style: TextStyle(color: Colors.black),),
                                  )
                                ],
                              ),
                              // Divider(thickness: 1,),
                              kin.isEmpty ? Text(''): Container(
                                height: 100,
                                width: 300,
                                // color: Colors.red,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                    itemCount:kin.length,
                                    itemBuilder: (context, index){
                                    // return Text('sok');
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${kin[index]['names']}'),
                                            Text('${kin[index]['phoneNo']}')
                                          ],
                                        ),
                                      );
                                }),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: ()async{
                  var data = await FlutterBarcodeScanner.scanBarcode(
                      "red",
                      "Cancel",
                      true,
                      ScanMode.QR);
                  // print('here is scanned data ${qrData.truncate()}');
                  setState(() {
                    print('found qr ${data}');
                    qrData = data;
                    qrData = qrData;
                    if(qrData != null){
                      getNamefromId(qrData);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                    child: Text('Scan QR'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
