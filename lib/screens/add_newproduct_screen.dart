import 'package:flutter/material.dart';

class AddNewProduct extends StatelessWidget {
  static const routeName = '/add_new_product';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Material(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      child: Text('Products / add'),
                    ),
                  ),
                  FlatButton.icon(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
