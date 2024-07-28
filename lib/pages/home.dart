import 'package:flutter/material.dart';

import 'Dashboard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          margin: EdgeInsets.all(5),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
                  child: SizedBox(
                    width: 300,
                    child: Image.asset('assets/bigezo.png'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 20.0, top: 20.0, right: 20.0, bottom: 10.0),
                  child: Text(
                    "CHC KIDS E-RECEIPT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(199, 15, 171, 4)),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(fontSize: 25),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.only(left: 0, top: 0, right: 0),
                  padding: EdgeInsets.all(20),
                  child: SizedBox(
                    width: 500.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(199, 15, 171, 4),
                        ),
                        elevation: MaterialStateProperty.all<double>(3),
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        printCredentials(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                  width: 200.0,
                ),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(
                left: 20.0, top: 20.0, right: 20.0, bottom: 10.0),
            child: Center(
                child: Text(
              "Developed by Alfred +256773913902",
              style: TextStyle(color: Color.fromARGB(95, 27, 27, 27)),
            ))),
      ],
    ));
  }

  void printCredentials(BuildContext context) {
    if (passwordController.text == "Apostolic") {
      // Navigate to Dashboard if credentials are correct
      passwordController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      // Handle incorrect credentials
      setState(() {
        errorMessage = "Invalid password";
      });
    }
  }
}
