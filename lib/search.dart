import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var userToken = '';
  var ListData = [];
  final TextEditingController _keyboard = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [Text("Search")],
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _keyboard,
                    decoration: const InputDecoration(
                      hintText: '请输入要搜索的内容',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    searchCompanyName();
                  },
                  child: Text("search"),
                  style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: ListData.length,
            itemBuilder: (BuildContext cxt, int i) {
              final item = ListData[i];
              var url = "http://192.168.1.100:10001/" + item['imgUrl'];
              return Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [Text('快递名称：' + item['name'])],
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [Text('联系电话：' + item['phone'])],
                          ),
                          Image.network(
                            url,
                            width: 180,
                            height: 180,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ))
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

  Future<void> searchCompanyName() async {
    var url = Uri.parse(
        "http://192.168.1.100:8080/city/api/logistics-inquiry/logistics_company/list?name=" +
            _keyboard.text);
    var header = {"Authorization": userToken};
    var response = await http.get(url, headers: header);
    var rspdata = jsonDecode(utf8.decode(response.bodyBytes));
    if (rspdata['data'].isNotEmpty) {
      setState(() {
        ListData = rspdata['data'];
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("搜索成功！")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("没有相关内容！")));
      // getCompanyListData();
    }
  }
}
