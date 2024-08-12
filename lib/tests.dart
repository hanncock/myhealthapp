import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/services.dart';

import 'logins.dart';

class AddTest extends StatefulWidget {
  final List ptndata;
  const AddTest({super.key,required this.ptndata});

  @override
  State<AddTest> createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  var test;
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
                  minLines: 2,
                  maxLines: 2,
                  onChanged: (val){
                    setState(() {
                      test = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Test',

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
                          "docId": Userdata[0]['id'],
                          "test":test,
                          "dateissued":"${DateTime.now()}"
                        };
                        var resu = await auth.saveMany("/api/hosi/test/add", data);
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
