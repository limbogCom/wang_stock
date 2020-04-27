import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wangstock/count_stock_model.dart';
import 'package:wangstock/product_detail.dart';
import 'package:wangstock/report_detail.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  ScrollController _scrollController = new ScrollController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  //Product product;
  List <CountStock>productAll = [];
  bool isLoading = true;
  int perPage = 30;
  String act = "Report";

  getCountStockProduct() async{

    final res = await http.get('https://wangpharma.com/API/checkStockProduct.php?PerPage=$perPage&act=$act');
    //print('https://wangpharma.com/API/checkStockProduct.php?PerPage=$perPage&act=$act');

    if(res.statusCode == 200){

      setState(() {
        isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((products) => productAll.add(CountStock.fromJson(products)));
        perPage = perPage + 30;

        print(productAll);
        print(perPage);

        return productAll;

      });


    }else{
      throw Exception('Failed load Json');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountStockProduct();

    _scrollController.addListener((){
      //print(_scrollController.position.pixels);
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        getCountStockProduct();
      }
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      getCountStockProduct();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? CircularProgressIndicator()
          :RefreshIndicator(
            key: refreshKey,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              controller: _scrollController,
              itemBuilder: (context, int index){
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailPage(productsVal: productAll[index])));
                  },
                  leading: Image.network('https://www.wangpharma.com/cms/product/${productAll[index].countStockProdPic}', fit: BoxFit.cover, width: 70, height: 70,),
                  title: Text('${productAll[index].countStockProdName}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${productAll[index].countStockProdCode}'),
                          Text('พนง.เปิด ${productAll[index].countStockEmpAdd}', style: TextStyle(color: Colors.green),),
                        ],
                      ),
                      Text('นับล่าสุด ${productAll[index].countStockNumCount} : ${productAll[index].countStockProdUnit1}', style: TextStyle(color: Colors.red),),
                      Text('เปิดงาน ${productAll[index].countStockDateAdd}', style: TextStyle(color: Colors.blueGrey),),
                      //productAll[index].recevicProductUnitNew == null
                      //? Text('หน่วยย่อย : ${productAll[index].recevicTCqtySub} ${productAll[index].recevicProductUnit}', style: TextStyle(color: Colors.lightBlue))
                      //: Text('หน่วยย่อย : ${productAll[index].recevicTCqtySub} ${productAll[index].recevicProductUnitNew}', style: TextStyle(color: Colors.lightBlue)),
                    ],
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.list, size: 40,),
                      onPressed: (){
                        //addToOrderFast(productAll[index]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ReportDetailPage(productsVal: productAll[index])));
                      }
                  ),
                );
              },
              itemCount: productAll != null ? productAll.length : 0,
            ),
            onRefresh: refreshList,
      ),
    );
  }
}
