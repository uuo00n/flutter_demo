import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsList extends StatefulWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  var userToken = '';
  var ListData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          body: GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, int x) {
              var item = ListData[x];
              return Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[100],
                child: Text(item['name']),
              );
            },
            itemCount: ListData.length,)
      );
  }

  Future<void> login() async {
    var url = Uri.parse("http://192.168.1.100:8080/city/api/login");
    var headers = {"Content-Type": "application/json"};
    var body = jsonEncode({"username": "hjb", "password": "hjb"});
    var response = await http.post(url, body: body, headers: headers);
    var rsp = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      userToken = rsp['token'];
    });
    print("内部存储token" + userToken);
    if (response.statusCode == 200) {
      if (rsp['code'] == 200 && userToken != null) {
        getCompanyListData();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('登陆成功！'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('登录失败！原因：' + rsp['msg']),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('网络错误请检查网络环境'),
      ));
    }
  }

  Future<void> getCompanyListData() async {
    var url = Uri.parse(
        "http://192.168.1.100:8080/city/api/logistics-inquiry/logistics_company/list");
    var header = {"Authorization": userToken};
    var response = await http.get(url, headers: header);
    var rspbody = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      ListData = rspbody['data'];
    });
  }
}
