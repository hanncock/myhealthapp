import 'package:flutter/material.dart';
import 'package:myhealth/Homepage.dart';
import 'package:myhealth/profile.dart';
import 'package:myhealth/qrscanner.dart';
import 'package:myhealth/services.dart';
import 'loader.dart';

class Logins extends StatefulWidget {
  const Logins({super.key});

  @override
  State<Logins> createState() => _LoginsState();
}

var Userdata = [];

class _LoginsState extends State<Logins> {

  AuthService auth = AuthService();

  var patinentNo;
  var password;
  var currentUSer = 'Patient';
  var loginPlaceholder = 'Patient...';
  var type = 'Patient';
  bool loading = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue.withOpacity(0.1)


      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                radius: 80,
                child: Icon(Icons.local_hospital,color: Colors.blue,size: 40,)
            ),
            SizedBox(height: 30,),
            Container(
              decoration: BoxDecoration(
                // color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10)
                  )
              ),
              child: Card(
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Container(
                      width: 380,
                      child: TextFormField(
                        onChanged: (val){
                          setState(() {
                            patinentNo = val;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '${loginPlaceholder}',

                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                   Container(
                     width: 380,
                     child: TextFormField(
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
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: ()async{
                        loading ? showDialog(
                            context: context, builder: (_) => const LoadingSpinCircle()
                        ): null;
                        var resu = await auth.SignIn(patinentNo, password, type);
                        // var resu = await auth.saveMany('/api/cred/add', data);
                        print(resu);
                        setState(() {
                          Userdata =  resu['data'];
                          loading = false;
                        });
                        switch(resu['data'][0]['type']){
                          case 'Patient':
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(datas: resu['data'])));
                            break;
                          case 'Medic':
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => QRScanner()));
                            break;
                          case 'Admin':
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile()));
                            break;
                          default:
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(datas: resu['data'])));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 80),
                          child: Text('Login',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onLongPress:(){
                              setState(() {
                                currentUSer = 'Admin';
                                loginPlaceholder = 'Admin...';
                                type='Admin';

                              });
                            },
                            onPressed: (){
                          if(currentUSer == 'Patient'){
                            setState(() {
                              currentUSer = 'Medic';
                              loginPlaceholder = 'MedicID...';
                              type = 'Medic';
                            });
                          }else{
                            setState(() {
                              currentUSer = 'Patient';
                              loginPlaceholder = 'Patient...';
                              type='Patient';

                            });
                          }

                        }, child: Text("Switch Login Profile",
                          style: TextStyle(
                              color: Colors.blue
                          ),)),
                      ],
                    ),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
