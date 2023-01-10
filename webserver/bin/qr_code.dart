import 'package:barcode_image/barcode_image.dart';
import 'package:image/image.dart';

class StudentifierQRCode {
  var dataMap;
  var qrCode;
  var filename;

  StudentifierQRCode(){
    this.filename = DateTime.now().toString() + hashCode.toString();
  }

  bool loadQrCodeData(var data) {
    this.dataMap = data;
    return true;
  }

  void drawQrCode() {
    qrCode = Image(300, 300);
    fill(qrCode, getColor(255, 255, 255));
    drawBarcode(qrCode, Barcode.qrCode(), dataMap);

  }

}
