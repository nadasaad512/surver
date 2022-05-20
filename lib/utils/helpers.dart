import 'dart:io';
import 'dart:typed_data';




mixin Helpers {

  SendData({required String ip,required  int port})async{
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
}
}
