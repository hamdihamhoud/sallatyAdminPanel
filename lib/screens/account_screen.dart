import 'package:adminpanel/widgets/add_copon.dart';
import 'package:adminpanel/widgets/web_drawer.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account';
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: WebDrawer(
              selectedIndex: 4,
            ),
          ),
          Expanded(
            flex: 5,
            child: AddCopon(),
          ),
        ],
      ),
    );
  }
}
