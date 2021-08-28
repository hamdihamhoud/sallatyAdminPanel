import 'package:adminpanel/providers/admin_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCopon extends StatefulWidget {
  @override
  _AddCoponState createState() => _AddCoponState();
}

class _AddCoponState extends State<AddCopon> {
  final key = GlobalKey<FormState>();

  double discountPercentage;

  int daysPeriod;

  String code = '';

  Future<void> _save() async {
    if (!key.currentState.validate()) return;
    key.currentState.save();
    code = await Provider.of<AdminFunctioins>(context, listen: false)
        .generateCopon(discountPercentage,
            DateTime.now().add(Duration(days: daysPeriod)).toIso8601String());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: Form(
            key: key,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Discount Percentage'),
                    validator: (value) {
                      if (value.isEmpty) return "Enter Discount Percentage";
                      if (double.tryParse(value) == null)
                        return "must be a number";
                      if (double.parse(value) > 100 || double.parse(value) < 0)
                        return "Invalid Percentage";
                      return null;
                    },
                    onSaved: (value) {
                      discountPercentage = double.parse(value);
                    },
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Valid for (days)'),
                    validator: (value) {
                      if (value.isEmpty) return "Enter Period";
                      if (int.tryParse(value) == null)
                        return "must be a number";
                      return null;
                    },
                    onSaved: (value) {
                      daysPeriod = int.parse(value);
                    },
                  ),
                ),
                TextButton(
                  onPressed: _save,
                  child: Text('Generate'),
                )
              ],
            ),
          ),
        ),
        if (code != '')
          Center(
              child: Text(
            'code: $code',
            style: TextStyle(fontSize: 18),
          )),
      ],
    );
  }
}
