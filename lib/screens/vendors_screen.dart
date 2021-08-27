import 'package:adminpanel/widgets/web_drawer.dart';
import 'package:flutter/material.dart';

class VendorsScreen extends StatefulWidget {
  static const routeName = '/vendors';
  VendorsScreen({Key key}) : super(key: key);

  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: WebDrawer(
              selectedIndex: 1,
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
