import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:wangstock/add_product.dart';
import 'package:wangstock/report.dart';
import 'package:wangstock/user.dart';

import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var username;

  int currentIndex = 0;
  List pages = [AddProductPage(), ReportPage(), UserPage()];

  getCodeEmpReceive() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("empCodeStock");
    });
    return username;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCodeEmpReceive();
  }

  _launchURL() async {
    const url = 'http://wangpharma.com/wang/warehouse-add-countstock.php';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget bottomNavBar = BottomNavigationBar(
        backgroundColor: Colors.white,
        fixedColor: Colors.green,
        unselectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_photos),
              title: Text('นับสินค้า', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('รายการ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              title: Text('ผู้ใช้', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
        ]
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("ระบบนับสินค้า-$username"),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            icon: Icon(Icons.cast_connected, size: 40, color: Colors.white,),
            color: Colors.black,
            onPressed: (){
              _launchURL();
            },
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
