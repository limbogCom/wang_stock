import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:soundpool/soundpool.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:wangstock/product_model.dart';
import 'package:wangstock/product_detail.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  var loading = false;

  //Sound scan barcode
  Future<int> _soundId;
  Soundpool _soundpool = Soundpool();

  List<Product> _product = [];

  @override
  void initState() {
    super.initState();

    _soundId = _loadSound();

  }

  searchProduct(searchVal) async{

    _product.clear();

    //productAll = [];

    final res = await http.get('https://wangpharma.com/API/product.php?SearchVal=$searchVal&act=Search');

    if(res.statusCode == 200){

      setState(() {

        var jsonData = json.decode(res.body);

        jsonData.forEach((products) => _product.add(Product.fromJson(products)));

        //products = json.decode(res.body);
        //recentProducts = json.decode(res.body);
        /*jsonData.forEach(([product, i]) {
          if(product['nproductMain'] != 'null'){
            products.add(product['nproductMain']);
          }
          print(product['nproductMain']);
        });*/
        print(_product);

        loading = true;

        return _product;

      });

    }else{
      throw Exception('Failed load Json');
    }
    //print(searchVal);
    //print(json.decode(res.body));
  }

  Future<int> _loadSound() async {
    var asset = await rootBundle.load("assets/sounds/beep.mp3");
    return await _soundpool.load(asset);
  }

  Future<void> _playSound() async {
    var _alarmSound = await _soundId;
    await _soundpool.play(_alarmSound);
  }

  /*scanBarcode() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", true, ScanMode.DEFAULT)
        .listen((barcode) {

      if(barcode != '-1'){

        /// barcode to be used
        print('barcode val $barcode');
        searchProduct(barcode);
        Future.delayed(Duration(seconds: 1), () {
          print(_product[0]);
          //addToOrderFast(_product[0]);
        });

        //playBeepSound();
        _playSound();

        //SystemSound.play(SystemSoundType.click);
        //scanBarcode();
      }else{
        showToastVal('ไม่พบสินค้า');
      }

    });
  }*/

  scanBarcode() async {
    try {
      var barcode = await BarcodeScanner.scan();
      _playSound();
      setState((){
        //this.barcode = barcode.rawContent;
        //print('999999999999${barcode.rawContent}');
        searchProduct(barcode.rawContent);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        _showAlertBarcode();
        print('Camera permission was denied');
      } else {
        print('Unknow Error $e');
      }
    } on FormatException {
      print('User returned using the "back"-button before scanning anything.');
    } catch (e) {
      print('Unknown error.');
    }
  }

  showToastVal(textVal){
    Fluttertoast.showToast(
        msg: textVal,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3
    );
  }

  void _showAlertBarcode() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('คุณไม่เปิดอนุญาตใช้กล้อง'),
        );
      },
    );
  }

  _getProductInfo(){

    if(!loading){
      return Text('....');
    }else{
      return Container(
        child: ListView.builder(
          shrinkWrap:true,
          itemCount: _product.length,
          itemBuilder: (context, i){
            final a = _product[i];
            return ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetailPage(productsVal: a)));
              },
              leading: Image.network('https://www.wangpharma.com/cms/product/${a.productPic}', fit: BoxFit.cover, width: 70, height: 70),
              title: Text('${a.productName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${a.productCode}'),
                  Text('หน่วยเล็กสุด : ${a.productUnit1}', style: TextStyle(color: Colors.blue), overflow: TextOverflow.ellipsis),
                ],
              ),
              trailing: IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.teal, size: 40,),
                  onPressed: (){
                    //addToOrderFast(a);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailPage(productsVal: a)));
                  }
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: SizedBox (
                width: double.infinity,
                height: 56,
                child: RaisedButton (
                  color: Colors.red,
                  onPressed: scanBarcode,
                  child: Text (
                    'Scan',
                    style: TextStyle (
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            _getProductInfo(),
          ],
        ),
      ),
    );
  }
}
