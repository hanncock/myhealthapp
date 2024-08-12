import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/AES.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGen extends StatefulWidget {
  final List data;
  const QrGen({super.key,required this.data});

  @override
  State<QrGen> createState() => _QrGenState();
}

class _QrGenState extends State<QrGen> {
  var enc = AESEncryption();



  @override
  Widget build(BuildContext context) {
    var id = widget.data[0]['id'].toString();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('${widget.data[0]}'),
            Center(
              child: QrImageView(
                  // data: "${(enc.encryptMsg(widget.data[0]['id']).base16).toString()}",
                  // data: "${int.parse(widget.data[0]['id'])}",
                  data: "${widget.data[0]['id']}",
                version: QrVersions.auto,
                size: 320,
              ),
            )
          ],
        ),
      ),
    );
  }
}
