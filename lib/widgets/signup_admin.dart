import 'package:adminpanel/providers/admin_functions.dart';
import 'package:adminpanel/screens/account_screen.dart';
import 'package:adminpanel/screens/delivery_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupAdminForm extends StatefulWidget {
  @override
  _SignupAdminFormState createState() => _SignupAdminFormState();
}

class _SignupAdminFormState extends State<SignupAdminForm> {
  final _key = GlobalKey<FormState>();
  String name = '';
  String password = '';
  String email = '';
  String number = '';
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    } else if (int.tryParse(s) != null) {
      return true;
    } else
      return false;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_key.currentState.validate()) {
      // Invalid!
      return;
    }
    _key.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AdminFunctioins>(context, listen: false).createAdmin(
        name,
        email,
        password,
        number,
      );
    } catch (error) {
      _showErrorDialog(error);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(AccountScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value.isEmpty) return "This can't be empty!";
                  if (isNumeric(value)) return "This can't be a number!";
                  return null;
                },
                onSaved: (value) {
                  name = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 5)
                    return 'Password is too short!';
                  return null;
                },
                onSaved: (value) {
                  password = value;
                },
              ),
              TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text)
                      return 'Passwords do not match!';
                    return null;
                  }),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@'))
                    return 'Invalid email!';
                  return null;
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefix: Text('09'),
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value.isEmpty) return "This can't be empty!";
                  if (value.length != 8 || !isNumeric(value))
                    return "Invalid Phone Number";
                  return null;
                },
                onSaved: (value) {
                  number = '09' + value;
                },
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : TextButton(
                      onPressed: _submit,
                      child: Text("Create"),
                    )
            ],
          ),
        ));
  }
}
