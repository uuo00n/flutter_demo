import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchObj extends StatefulWidget {
  const SearchObj({Key? key, required this.id, required this.token})
      : super(key: key);

  final id;
  final token;

  @override
  State<SearchObj> createState() => _SearchObjState();
}

class _SearchObjState extends State<SearchObj> {
  var CompData = {};
  var userToken = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // login();
    getAboutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("公司详细"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text(widget.id.toString()),
            ],
          ),
          if (CompData.isNotEmpty)
            Row(
              children: [
                Title(color: Colors.red, child: Text(CompData['name'])),
              ],
            )
        ],
      ),
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
        getAboutData();
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

  Future<void> getAboutData() async {
    var url = Uri.parse(
        'http://192.168.1.100:8080/city/api/logistics-inquiry/logistics_company/' +
            widget.id.toString());
    var header = {
      'Content-Type': 'application/json',
      "Authorization": widget.token.toString()
    };
    var response = await http.get(url, headers: header);
    var rsp = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      CompData = rsp['data'];
    });
  }


}
