import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var ListData = [];

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          children: [
            Row(children: [Text("home"),],),
            Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: '请输入账号',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return '请输入内容';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: '请输入密码',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return '请输入内容';
                        }
                        return null;
                      },
                    ),
                    Center(child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),)
                  ],
                ),
              ),
            ),
            Row(
              children: [],
            )
          ],
        ),
      ),
    );
  }
  //登录请求
  Future<void> login() async {
    var url = Uri.parse("http://192.168.1.100:8080/city/api/login");
    var headers = {
      "Content-Type": "application/json"
    };
    var body = jsonEncode({
      "username": _usernameController.text,
      "password": _passwordController.text
    });
    var response = await http.post(url,body: body,headers: headers);
    var rsp = jsonDecode(utf8.decode(response.bodyBytes));
    print(rsp['token']);

    if(rsp['code']==200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('登陆成功！'),
      ));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('登录失败！原因：'+rsp['msg']),
      ));
    }
  }

  Future<void> getData() async {
    var url = Uri.parse('http://192.168.1.100:8080/city/api/movie/film/list');
    var response = await http.get(url);
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      ListData = data['rows'];
    });
  }
}
