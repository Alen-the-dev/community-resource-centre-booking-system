import 'package:flutter/material.dart';

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text("EMAIL ADDRESS"),
      Container(child: Row(children: [Icon(Icons.email),
      Text("user@example.com"),
      ],),)
    ],);
  }
}