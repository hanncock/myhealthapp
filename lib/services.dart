import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

// get: ^4.6.5

class AuthService{

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  var url = "https://www.medqr.or.ke/index.php";
  // var url = "https://4fa2-197-248-34-79.ngrok-free.app";

  SignIn(email, password,type) async {
    String all = url.toString()+'/api/hosi/creds/list?username=${email}&password=${password}&type=${type}';
    print(all);
    // Map data = {
    //   "username": email,
    //   "password": password,
    //   "type":type
    // };
    //
    // var send = jsonEncode(data);
    // var resu = await http.post(Uri.parse(all), body: send, headers: headers);
    var resu = await http.get(Uri.parse(all), headers: headers);
    // User? use = _userdata(jsonDecode(response.body));
    print((resu.body));
    return jsonDecode(resu.body);
  }


  getMany(endoint)async{
    var all = url.toString()+'$endoint';
    print(all);
    var resu = await http.get(Uri.parse(all));
    return jsonDecode(resu.body);
  }

  saveMany(endpoint,data)async{
    // Map data = {
    //   "username": email,
    //   "password": password,
    //   "type":type
    // };
    var all = url+endpoint;
    // print(all);

    var send = jsonEncode(data);
    // print(send);
    var resu = await http.post(Uri.parse(all), body: send, headers: headers);
    // print(resu);
    print(resu.body);
    print(jsonDecode(resu.body));
    return (jsonDecode(resu.body));
    return resu;
  }

  delete(endpoint,id)async{
    var all = await url+endpoint;
    return (all);
    // return jsonDecode(source);
    // var resu = await http.post()
  }


}