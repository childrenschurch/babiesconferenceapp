import 'package:chc_kids/pages/ClientForm.dart';
import 'package:chc_kids/pages/home.dart';

import 'pages/Dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}
