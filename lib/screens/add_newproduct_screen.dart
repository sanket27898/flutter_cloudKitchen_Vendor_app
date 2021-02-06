import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/category_list.dart';

class AddNewProduct extends StatefulWidget {
  static const routeName = '/add_new_product';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formkey = GlobalKey<FormState>();

  List<String> _collection = [
    'Featured Products',
    'Best Selling',
    'recently added',
  ];
  String dropdownValue;

  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  File _image;
  bool _visible = false;
  bool _track = false;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formkey,
          child: Column(
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
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: 'GENERAL',
                  ),
                  Tab(
                    text: 'INVENTORY',
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Product Name*',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'About Product*',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      _provider.getProductImage().then((image) {
                                        setState(() {
                                          _image = image;
                                        });
                                      });
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: Center(
                                          child: _image == null
                                              ? Text('Select Image')
                                              : Image.file(_image),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Price*', //final selling price
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText:
                                        'Compared Price*', // price before discount
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Collection',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      DropdownButton<String>(
                                        hint: Text('Select Collection'),
                                        value: dropdownValue,
                                        icon: Icon(Icons.arrow_drop_down),
                                        onChanged: (String value) {
                                          setState(() {
                                            dropdownValue = value;
                                          });
                                        },
                                        items: _collection
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Brand',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'SKU', //item code
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Category',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _categoryTextController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: 'not selected',
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit_outlined),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CategoryList();
                                              }).whenComplete(() {
                                            setState(() {
                                              _categoryTextController.text =
                                                  _provider.selectedCategory;
                                              _visible = true;
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _visible,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sub Category',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                _subCategoryTextController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: 'not selected',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SubCategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                _subCategoryTextController
                                                        .text =
                                                    _provider
                                                        .selectedSubCategory;
                                              });
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Weight.  eg:- Kg, gm , etc.',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Tax %',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text('Track Inventory'),
                              activeColor: Theme.of(context).primaryColor,
                              subtitle: Text(
                                'Switch ON to track Inventory',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              value: _track,
                              onChanged: (selected) {
                                setState(() {
                                  _track = !_track;
                                });
                              },
                            ),
                            Visibility(
                              visible: _track,
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Inventory Quantity*',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText:
                                                'Inventory low stock quantity ',
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
