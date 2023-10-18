import 'package:flutter/material.dart';


const bgColor =Color(0xfffafafa);


class QRScanner extends StatelessWidget {
  const QRScanner ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('QR Code Scanner',
          style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,  
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(flex: 4, child: Container(
              child:const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Place the QR code in the area",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,  
                  ),
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    "Scanning will be started automatically",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
              ],
                ) 
            )),
            Expanded(flex: 4, child: Container(color: Colors.green,)),
            Expanded(flex: 4,
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "Devloped by Gistra.S.L"
                  ,style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    letterSpacing: 1
                  ),
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}
