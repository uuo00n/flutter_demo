import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [Text("Search")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  child: Center(
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {},
                ),
              )),
              Container(
                child: ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {},
                ),
              )
            ],
          ),
          Row(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(child: const Text('Button 1'), onPressed: () {}),
                  TextButton(child: const Text('Button 2'), onPressed: () {}),
                  TextButton(child: const Text('Button 3'), onPressed: () {}),
                ],
              )
            ],
          ),
          Row(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("search"),
                style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
              )
            ],
          ),
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
    print(rsp['token']);

    if (rsp['code'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('登陆成功！'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('登录失败！原因：' + rsp['msg']),
      ));
    }
  }
}
