import 'package:adminpanel/providers/admin_functions.dart';
import 'package:adminpanel/providers/auth.dart';
import 'package:adminpanel/widgets/add_copon.dart';
import 'package:adminpanel/widgets/extend_premuim.dart';
import 'package:adminpanel/widgets/signup_admin.dart';
import 'package:adminpanel/widgets/signup_delivery_form.dart';
import 'package:adminpanel/widgets/web_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account';
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminFunctioins>(context);
    final auth = Provider.of<AuthProvider>(context);

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: AddCopon(),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: SignupAdminForm(),
                                ),
                              );
                            },
                            child: Text('Add new admin'),
                          ),
                        ),
                        Container(
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: ExtendPremium(),
                                ),
                              );
                            },
                            child: Text('Extend vendor period'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          auth.deleteAdmin();
                        },
                        child: Text(
                          "Delete Your Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
