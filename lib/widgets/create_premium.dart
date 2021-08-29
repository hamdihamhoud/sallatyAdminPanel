import 'package:adminpanel/providers/admin_functions.dart';
import 'package:adminpanel/screens/delivery_screen.dart';
import 'package:adminpanel/screens/vendors_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePremium extends StatefulWidget {
  @override
  _CreatePremiumState createState() => _CreatePremiumState();
}

class _CreatePremiumState extends State<CreatePremium> {
  final _key = GlobalKey<FormState>();
  String email = '';
  int years;
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
      await Provider.of<AdminFunctioins>(context, listen: false)
          .createPremium(email, years);
    } catch (error) {
      _showErrorDialog(error);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(VendorsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                  labelText: 'Yeras',
                ),
                validator: (value) {
                  if (value.isEmpty) return "This can't be empty!";
                  if (!isNumeric(value)) return "Invalid Number";
                  return null;
                },
                onSaved: (value) {
                  years = int.parse(value);
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
