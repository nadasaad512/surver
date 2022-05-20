
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:modbus/modbus.dart' as modbus;
import 'package:server/utils/helpers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget with Helpers {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initScreen();
  }

  @override
  void dispose() {
    super.dispose();
   releaseResource();
  }

  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: new Text(' XT MONITOR'),
      ),
      body: potraitFirstScreen(context)
    );
  }
}






String address = '192.168.1.226';
int port = 50000;

final SendBuf = Uint8List(12);

Uint8List  RecBuf= Uint8List.fromList([]);
int? i;

StreamSubscription<Uint8List>?  nada;

bool verifylenghtport = false;
bool verifylenghtaddr = false;

//UserModbus userModbus;
TextEditingController usraddress = TextEditingController();
TextEditingController usrport = TextEditingController();





Widget potraitFirstScreen(BuildContext context) {
  return Container(
    child: ListView(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width * 0.35,
          child: TextButton(


            onPressed:()async{
              print("click enter ");
              await   connectUPS;
              print("after connect modpus ");

            },



            // onPressed: (){
            //   ServerSocket.bind('192.168.1.226', 50000)
            //       .then((serverSocket) {
            //     serverSocket.listen((socket) {
            //       print("done");
            //       socket.cast<List<int>>().transform(utf8.decoder).listen(print);
            //     });
            //   });
            // },
            child: Text("Enter"),
          ),
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('images/Dkc.png'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Insert IP UPS Address...",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              controller: usraddress,
              onChanged: (text) {
                if (usraddress.text.length > 4) {
                  verifylenghtaddr = true;
                } else {
                  verifylenghtaddr = false;
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.1,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                hintText: "Insert Port...",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              controller: usrport,
              onChanged: (text) {
                if (usrport.text.length == 5) {
                  verifylenghtport = true;
                } else {
                  verifylenghtport = false;
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.04,
        ),


        TextButton(
          child: Text("Data"),
          onPressed: (){
            print("nada is ${nada}");
          },
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          ButtonTheme(
            minWidth: MediaQuery.of(context).size.width * 0.89,
            height: 20,
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
              color: Colors.black,
              textColor: Colors.yellow,
              padding: EdgeInsets.all(10.0),
              onPressed: ()async{
                print("click in connect");
               await Socket.connect('10.18.64.170', 50000,).then((socket)
               {
                 var message = Uint8List(12);
                 var bytedata = ByteData.view(message.buffer);
                 bytedata.setUint8(0, 0);
                 bytedata.setUint8(1, 0);
                 bytedata.setUint8(2, 0);
                 bytedata.setUint8(3, 0);
                 bytedata.setUint8(4, 0);
                 bytedata.setUint8(5, 6);
                 bytedata.setUint8(6, 0);
                 bytedata.setUint8(7, 5);
                 bytedata.setUint8(8, 0x0C);
                 bytedata.setUint8(9, 0x30);
                 bytedata.setUint8(10, 0xFF);
                 bytedata.setUint8(11, 0x00);
                 socket.add(message);


                });















                    },
              child: Text(
                "Connect".toUpperCase(),
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ]),
      ],
    ),
  );




}
 ReadRegisters(Uint16List A, Uint16List n, Uint16List W)
 {



SendBuf[0] = 0;
SendBuf[1] = 0;
SendBuf[2] = 0;
SendBuf[3] = 0;
SendBuf[4] = 0;
SendBuf[5] = 6;
SendBuf[6] = 0;
SendBuf[7] = 3;
// SendBuf[8] = (byte)(A >> 8);
// SendBuf[9] = (byte)(A % 256);
// SendBuf[10] = (byte)(n >> 8);
// SendBuf[11] = (byte)(n % 256);




}




Uint16List DevToAddrW (String Ads)
{
  try
  {
    String dev, N;
    dev = Ads.substring(0,1);
    N = Ads.substring(1, Ads.length - 1);



    switch (dev)
    {
      case "S":
      case "s":
        Uint16List  m=  Uint16List.fromList([0x0+int.parse(N)]);
        return m;
      case "X":
      case "x":
        Uint16List  m=  Uint16List.fromList([0x400+int.parse(N)]);
        return m;
      case "Y":
      case "y":
        Uint16List  m=  Uint16List.fromList([0x500+int.parse(N)]);
        return m ;
      case "T":
      case "t":
        Uint16List  m=  Uint16List.fromList([0x600+int.parse(N)]);
        return m;
      case "C":
      case "c":
        Uint16List  m=  Uint16List.fromList([0xE00+int.parse(N)]);
        return m;
      case "M":
      case "m":
        Uint16List  m=  Uint16List.fromList([0x800+int.parse(N)]);
        return m;
      case "D":
      case "d":
        Uint16List  m=  Uint16List.fromList([0x1000+int.parse(N)]);
        return m;

    // S +0
    // X +400
    // Y +500
    // T +600
    // M +800
    // C +E00*
    // D +1000

    }
    Uint16List  m=  Uint16List.fromList([int.parse(dev)]);
    return m;
  }
  on Exception catch (_)
  {
    Uint16List  m=  Uint16List.fromList([0xFFFF]);
    return m;
  }


}













void initScreen() {


  usraddress.addListener(remCharAddr);
  usrport.addListener(remCharPort);
}

void remCharPort() {
  String cr = "\r";
  final text = usrport.text.replaceAll("-", "").replaceAll(",", "").replaceAll(cr, "");

  usrport.value = usrport.value.copyWith(
      text: text,
      selection:
      TextSelection(baseOffset: text.length, extentOffset: text.length),
      composing: TextRange.empty);
}

void remCharAddr() {
  String cr = "\r";
  final text = usraddress.text
      .replaceAll("-", "")
      .replaceAll(",", "")
      .replaceAll(cr, "");

  usraddress.value = usraddress.value.copyWith(
      text: text,
      selection:
      TextSelection(baseOffset: text.length, extentOffset: text.length),
      composing: TextRange.empty);
}

void releaseResource() {
  usraddress.dispose();
  usrport.dispose();
}

void connectUPS() async{
  //userModbus.address = usraddress.text;
  address = usraddress.text;
  port = int.parse(usrport.text);

  //print("Address:" + userModbus.address);
  //print("Port:" + userModbus.port.toString());

  //connect(userModbus.address, userModbus.port);
 await connecttoUPS(address, port);
}

bool enableconnectionbutton() {
  if (verifylenghtaddr && verifylenghtport) {
    return true;
  } else {
    return false;
  }
}

 connecttoUPS(String address, int porta) async  {


  var client =await modbus.createTcpClient("192.168.1.226", port: 50000, mode: modbus.ModbusMode.rtu);
  print("creet client in modpus");
  try {

    print ("try connect with modpus");
    await client.connect();
    print ("after connect with modpus");
  } finally {
    print ("error in  modpus");
    client.close();

    print ("closs client in   modpus");
    // var registers = await client.readInputRegisters(0x0006, 4);
    // for (int i = 0; i < registers.length; i++) {
    //   print("REG_I:" + registers.elementAt(i).toString());
    // }
  }



 // Uint16List DevToAddrW(String Ads)
 //  {
 //    try
 //    {
 //      String dev, N;
 //      dev = Ads.Substring(0, 1);
 //      N = Ads.Substring(1, Ads.Length - 1);
 //
 //      switch (dev)
 //      {
 //        case "S":
 //        case "s":
 //          return (Uint16List)(0x0 + UInt16.Parse(N));
 //        case "X":
 //        case "x":
 //          return (UInt16)(0x400 + UInt16.Parse(N));
 //        case "Y":
 //        case "y":
 //          return (UInt16)(0x500 + UInt16.Parse(N));
 //        case "T":
 //        case "t":
 //          return (UInt16)(0x600 + UInt16.Parse(N));
 //        case "C":
 //        case "c":
 //          return (UInt16)(0xE00 + UInt16.Parse(N));
 //        case "M":
 //        case "m":
 //          return (UInt16)(0x800 + UInt16.Parse(N));
 //        case "D":
 //        case "d":
 //          return (UInt16)(0x1000 + UInt16.Parse(N));
 //
 //      // S +0
 //      // X +400
 //      // Y +500
 //      // T +600
 //      // M +800
 //      // C +E00*
 //      // D +1000
 //
 //      }
 //      return (UInt16)(UInt16.Parse(dev));
 //    }
 //    catch
 //    {
 //      return 0xFFFF;
 //    }
 //  }






}


/*
import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  late Socket socket;
  String name="nada";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name == null ? 'NO CONNECTED' : name),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Connect'),
              onPressed: (){
                connect();
              },
            ),
            RaisedButton(
              child: Text('Send Data'),
              onPressed: (){
                sendData();
              },
            )
          ],
        ),
      ),
    );
  }

  // Socket connection
  void connect() {
    Socket.connect("10.12.195.114", 50000).then((Socket sock) {
      socket = sock;
      socket.listen(
          dataHandler,
          onError: errorHandler,
          onDone: doneHandler,
          cancelOnError: false
      );
    });
  }
  void dataHandler(data){
    setState(() {
      name = new String.fromCharCodes(data).trim();
    });
  }
  void errorHandler(error, StackTrace trace){
    print(error);
  }
  void doneHandler(){
    socket.destroy();
  }
  void sendData(){
    //socket.write(...)
  }
}
 */