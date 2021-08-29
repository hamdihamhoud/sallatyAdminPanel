import 'package:adminpanel/providers/auth.dart';
import 'package:adminpanel/screens/account_screen.dart';
import 'package:adminpanel/screens/feedback_screen.dart';
import 'package:adminpanel/screens/orders_screen.dart';
import 'package:adminpanel/screens/delivery_screen.dart';
import 'package:adminpanel/screens/vendors_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebDrawer extends StatefulWidget {
  final int selectedIndex;
  WebDrawer({this.selectedIndex});
  @override
  _WebDrawerState createState() =>
      _WebDrawerState(selectedIndex: selectedIndex);
}

class _WebDrawerState extends State<WebDrawer> {
  int selectedIndex;
  _WebDrawerState({this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Container(
      color: theme.primaryColor,
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset('images/logo_named.png'),
          ),
          ListTile(
            selected: selectedIndex == 0 ? true : false,
            leading: Icon(Icons.shopping_cart_outlined),
            title: Text('Orders'),
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
            selectedTileColor: Color(0xFF333333),
          ),
          ListTile(
            selected: selectedIndex == 1 ? true : false,
            leading: Icon(Icons.verified),
            title: Text('Vendors'),
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
              Navigator.pushReplacementNamed(context, VendorsScreen.routeName);
            },
            selectedTileColor: Color(0xFF333333),
          ),
          ListTile(
            selected: selectedIndex == 3 ? true : false,
            leading: Icon(Icons.delivery_dining),
            title: Text('Delivery'),
            onTap: () {
              setState(() {
                selectedIndex = 3;
              });
              Navigator.pushReplacementNamed(context, DeliveryScreen.routeName);
            },
            selectedTileColor: Color(0xFF333333),
          ),
          ListTile(
            selected: selectedIndex == 2 ? true : false,
            leading: Icon(Icons.feedback),
            title: Text('Feedback'),
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
              Navigator.pushReplacementNamed(context, FeedbackScreen.routeName);
            },
            selectedTileColor: Color(0xFF333333),
          ),
          ListTile(
            selected: selectedIndex == 4 ? true : false,
            leading: Icon(Icons.account_circle),
            title: Text('Account'),
            onTap: () {
              setState(() {
                selectedIndex = 4;
              });
              Navigator.pushReplacementNamed(context, AccountScreen.routeName);
            },
            selectedTileColor: Color(0xFF333333),
          ),
          ListTile(
            selected: selectedIndex == 5 ? true : false,
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
