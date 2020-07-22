import 'package:flutter/material.dart';

Future<bool> getSurity(context, {String text = 'Are you sure?'}) async {
  bool response = false;
  await showDialog(
      barrierDismissible: text == 'Are you sure?' ? true : false,
      context: context,
      builder: (context) {
        return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(text),
            actions: <Widget>[
              MaterialButton(
                child: Text('Yes',
                    style: TextStyle(color: Color.fromRGBO(35, 205, 99, 1.0))),
                onPressed: () {
                  response = true;
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                  child: Text('No',
                      style:
                          TextStyle(color: Color.fromRGBO(35, 205, 99, 1.0))),
                  onPressed: () {
                    response = false;
                    Navigator.of(context).pop();
                  })
            ]);
      });
  return response;
}
