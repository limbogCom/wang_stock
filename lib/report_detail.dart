import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wangstock/count_stock_his_model.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportDetailPage extends StatefulWidget {

  var productsVal;
  ReportDetailPage({Key key, this.productsVal}) : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {

  ScrollController _scrollController = new ScrollController();

  //Product product;
  List <CountStockHis>countStockHis = [];
  bool isLoading = true;
  int perPage = 30;
  String act = "ReportDetail";

  var empCodeStock;

  getCountStockProductHis() async{

    final res = await http.get('https://wangpharma.com/API/checkStockProduct.php?PerPage=$perPage&CTcode=${widget.productsVal.countStockCode}&act=$act');

    if(res.statusCode == 200){

      setState(() {
        isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((products) => countStockHis.add(CountStockHis.fromJson(products)));
        perPage = perPage + 30;

        print(countStockHis);
        print(perPage);

        return countStockHis;

      });

    }else{
      throw Exception('Failed load Json');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountStockProductHis();

    _scrollController.addListener((){
      //print(_scrollController.position.pixels);
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        getCountStockProductHis();
      }
    });
  }

  confirmCountStock(ctlID) async{

    print(ctlID);
    if(ctlID != null) {
      var uri = Uri.parse("https://wangpharma.com/API/checkStockProduct.php");
      var request = http.MultipartRequest("POST", uri);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      empCodeStock = prefs.getString("empCodeStock");

      //request.fields['ct_code'] = ;
      request.fields['act'] = 'Confirm';
      request.fields['ctl_id'] = ctlID;
      //request.fields['ctl_stock'] = productVal.productStockQ;
      request.fields['emp_pickingorder'] = empCodeStock;

      var response = await request.send();

      if (response.statusCode == 200) {

        var respStr = await response.stream.bytesToString();

        print("confirm OK");
        print(respStr);
        showToast('ยืนยันสำเร็จ');
        //Navigator.pop(context);
        Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);

        /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home())).then((r){
        });*/

        //Navigator.pop(context);

      } else {
        print("add Error");
      }

      //showToastAddFast();
      //Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
      //Navigator.pop(context);

    }else{
      _showAlert();
    }
  }

  showToast(textVal){
    Fluttertoast.showToast(
        msg: textVal,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3
    );
  }

  showDialogDelConfirm(id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("แจ้งเตือน"),
          content: Text("ยืนยันลบรายการ"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              color: Colors.red,
              child: Text("ยกเลิก",style: TextStyle(color: Colors.white, fontSize: 18),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 100,
            ),
            FlatButton(
              color: Colors.green,
              child: Text("ตกลง",style: TextStyle(color: Colors.white, fontSize: 18),),
              onPressed: () {
                removeCountStockHis(id);
                //Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  removeCountStockHis(cthID) async{

    print(cthID);

    if(cthID != null) {

      var uri = Uri.parse("https://wangpharma.com/API/checkStockProduct.php");
      var request = http.MultipartRequest("POST", uri);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      empCodeStock = prefs.getString("empCodeStock");

      //request.fields['ct_code'] = ;
      request.fields['act'] = 'Del';
      request.fields['del_cth_id'] = cthID;
      //request.fields['ctl_stock'] = productVal.productStockQ;
      request.fields['emp_pickingorder'] = empCodeStock;

      var response = await request.send();

      if (response.statusCode == 200) {

        var respStr = await response.stream.bytesToString();

        print("add OK");
        print(respStr);

        showToast('ลบรายการ');
        Navigator.pop(context);

        //Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);

        /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home())).then((r){
        });*/

        //Navigator.pop(context);

      } else {
        print("add Error");
      }

      //showToastAddFast();
      //Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
      //Navigator.pop(context);

    }else{
      _showAlert();
    }

  }

  _showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('คุณกรอกรายละเอียดไม่ครบถ้วน'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.product.productName.toString()),
        title: Text(widget.productsVal.countStockProdName),
        actions: <Widget>[
          /*IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: (){
                      //Navigator.pushReplacementNamed(context, '/Order');
                    }
                )*/
        ],
      ),
      body: isLoading ? CircularProgressIndicator()
          :ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        controller: _scrollController,
        itemBuilder: (context, int index){
          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
            onTap: (){
              /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetailPage(productsVal: countStockHis[index])));*/
            },
            //leading: Image.network('https://www.wangpharma.com/cms/product/${countStockHis[index].countStockProdPic}', fit: BoxFit.cover, width: 70, height: 70,),
            title: Text('${countStockHis[index].countStockHisDateCount}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('จำนวนนับ ${countStockHis[index].countStockHisNumCount} : ${countStockHis[index].countStockHisProdUnit}', style: TextStyle(color: Colors.red),),
                    Text('พนง.นับ ${countStockHis[index].countStockHisEmpCount}', style: TextStyle(color: Colors.green),),
                  ],
                ),
                Text('Comment : ${countStockHis[index].countStockHisComment}', style: TextStyle(color: Colors.blueGrey),),
                //countStockHis[index].recevicProductUnitNew == null
                //? Text('หน่วยย่อย : ${countStockHis[index].recevicTCqtySub} ${countStockHis[index].recevicProductUnit}', style: TextStyle(color: Colors.lightBlue))
                //: Text('หน่วยย่อย : ${countStockHis[index].recevicTCqtySub} ${countStockHis[index].recevicProductUnitNew}', style: TextStyle(color: Colors.lightBlue)),
              ],
            ),
            trailing: IconButton(
                icon: Icon(Icons.backspace, size: 40, color: Colors.red,),
                onPressed: (){
                  showDialogDelConfirm(countStockHis[index].countStockHisId);
                  //addToOrderFast(countStockHis[index]);
                }
            ),
          );
        },
        itemCount: countStockHis != null ? countStockHis.length : 0,
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Column(
          children: <Widget>[
            Container(
              child: MaterialButton(
                color: Colors.deepOrange,
                textColor: Colors.white,
                minWidth: double.infinity,
                height: 50,
                child: Text(
                  "ยืนยันรายการ",
                  style: new TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                //onPressed: (){Navigator.pushReplacementNamed(context, '/Home');},
                onPressed: () {
                  confirmCountStock(widget.productsVal.countStockId);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
