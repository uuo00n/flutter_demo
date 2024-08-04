import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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
            mainAxisAlignment: MainAxisAlignment.center,
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
        ],
      ),
    );
  }
}
