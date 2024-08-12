import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myhealth/logins.dart';
import 'package:myhealth/services.dart';

class AddPrescription extends StatefulWidget {
  final List ptndata;
  const AddPrescription({super.key,required this.ptndata});

  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {

  var prescription;
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 380,
              child: TextFormField(
                minLines: 5,
                maxLines: 5,
                onChanged: (val){
                  setState(() {
                    prescription = val;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prescription',

                ),
              ),
            ),
            SizedBox(height: 10,),
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
                      //
                      // id          | varchar(255) | NO   | PRI | NULL    |       |
                      // | patientId   | varchar(255) | YES  |     | NULL    |       |
                      // | doctorId    | varchar(255) | YES  |     | NULL    |       |
                      // | description | varchar(255) | YES  |     | NULL    |       |
                      // | dateissued

                      Map data ={
                        "id":null,
                        "patientId": "${widget.ptndata[0]['id']}",
                        "doctorId": Userdata[0]['id'],
                        "description":prescription,
                        "dateissued":"${DateTime.now()}"
                      };
                      var resu = await auth.saveMany("/api/hosi/prescription/add", data);
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
          ],
        ),
      )
    );
  }
}
