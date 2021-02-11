import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vender_app_flutter/providers/product_provider.dart';
import 'package:vender_app_flutter/services/firebase_services.dart';
import 'package:vender_app_flutter/widgets/category_list.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;
  EditViewProduct({this.productId});
  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  final _formkey = GlobalKey<FormState>();

  List<String> _collection = [
    'Featured Products',
    'Best Selling',
    'recently added',
  ];
  String dropdownValue;

  var _brandText = TextEditingController();
  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _weightText = TextEditingController();
  var _priceText = TextEditingController();
  var _compredPriceText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _taxTextController = TextEditingController();
  DocumentSnapshot doc;
  double discount;
  String image;
  String categoryImage;
  File _image;
  // bool _visible = false;
  bool _editing = true; //now cannot edit . only can view.

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _brandText.text = document.data()['brand'];
          _skuText.text = document.data()['sku'];
          _productNameText.text = document.data()['productName'];
          _weightText.text = document.data()['weight'];
          _priceText.text = document.data()['price'].toString();
          _compredPriceText.text = document.data()['comparedPrice'].toString();
          var diffrence =
              int.parse(_compredPriceText.text) - double.parse(_priceText.text);
          discount = (diffrence / int.parse(_compredPriceText.text) * 100);
          image = document.data()['productImage'];
          _descriptionText.text = document.data()['description'];
          _categoryTextController.text =
              document.data()['category']['mainCategory'];
          _subCategoryTextController.text =
              document.data()['category']['subCategory'];
          dropdownValue = document.data()['collection'];
          _stockTextController.text = document.data()['stockQty'].toString();
          _lowStockTextController.text =
              document.data()['lowStockQty'].toString();
          _taxTextController.text = document.data()['tax'].toString();
          categoryImage = document.data()['category']['categoryImage'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          FlatButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 18,
                )
              ],
            ),
            onPressed: () {
              setState(() {
                _editing = !_editing;
              });
            },
          )
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Text(
                      'Cancle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AbsorbPointer(
                absorbing: _editing,
                child: InkWell(
                  onTap: () {
                    if (_formkey.currentState.validate()) {
                      EasyLoading.show(status: 'Loading...');
                      if (_image != null) {
                        // first upload new image and save data
                        _provider
                            .uploadProductImage(
                                _image.path, _productNameText.text)
                            .then((url) {
                          if (url != null) {
                            _provider.updateProduct(
                              context: context,
                              productName: _productNameText.text,
                              weight: _weightText.text,
                              tax: double.parse(_taxTextController.text),
                              stockQty: int.parse(_stockTextController.text),
                              sku: _skuText.text,
                              price: double.parse(_priceText.text),
                              lowStockQty:
                                  int.parse(_lowStockTextController.text),
                              description: _descriptionText.text,
                              collection: dropdownValue,
                              brand: _brandText.text,
                              comparedPrice: int.parse(_compredPriceText.text),
                              productId: widget.productId,
                              image: image,
                              category: _categoryTextController.text,
                              subCategory: _subCategoryTextController.text,
                              categoryImage: categoryImage,
                            );
                            EasyLoading.dismiss();
                          }
                        });
                      } else {
                        //no need to change image, so just save data , no need to upload image

                        _provider.updateProduct(
                          context: context,
                          productName: _productNameText.text,
                          weight: _weightText.text,
                          tax: double.parse(_taxTextController.text),
                          stockQty: int.parse(_stockTextController.text),
                          sku: _skuText.text,
                          price: double.parse(_priceText.text),
                          lowStockQty: int.parse(_lowStockTextController.text),
                          description: _descriptionText.text,
                          collection: dropdownValue,
                          brand: _brandText.text,
                          comparedPrice: int.parse(_compredPriceText.text),
                          productId: widget.productId,
                          image: image,
                          category: _categoryTextController.text,
                          subCategory: _subCategoryTextController.text,
                          categoryImage: categoryImage,
                        );
                        EasyLoading.dismiss();
                      }
                      //reset only after Saving Completed
                      _provider.resetProvider();
                    }
                  },
                  child: Container(
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                height: 30,
                                child: TextFormField(
                                  // enabled: _editing ? false : true, this is my i will update it later
                                  controller: _brandText,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      hintText: 'Brand',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.1),
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('SKU : '),
                                  Container(
                                    width: 70,
                                    child: TextFormField(
                                      controller: _skuText,
                                      style: TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            child: TextFormField(
                              controller: _productNameText,
                              style: TextStyle(fontSize: 30),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: TextFormField(
                              controller: _weightText,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                child: TextFormField(
                                  controller: _priceText,
                                  style: TextStyle(fontSize: 18),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: 'Rs '),
                                ),
                              ),
                              Container(
                                width: 80,
                                child: TextFormField(
                                  controller: _compredPriceText,
                                  style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.lineThrough),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: 'Rs '),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.red,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    "${discount.toStringAsFixed(0)}% OFF",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            'Inclusice of all Taxes',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _provider.getProductImage().then((image) {
                                setState(() {
                                  _image = image;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _image != null
                                  ? Image.file(
                                      _image,
                                      height: 300,
                                      width: double.infinity,
                                    )
                                  : Image.network(
                                      image,
                                      height: 300,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                          Text(
                            'Adout this Product',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              maxLines: null,
                              controller: _descriptionText,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: Colors.grey),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
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
                                  'Category :',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      controller: _categoryTextController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Select Category';
                                        }
                                        return null;
                                      },
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
                                ),
                                Visibility(
                                  visible: _editing ? false : true,
                                  child: IconButton(
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
                                          // _visible = true;
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            child: Row(
                              children: [
                                Text(
                                  'Sub Category :',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: _subCategoryTextController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Select Subcategory';
                                        }
                                        return null;
                                      },
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
                                ),
                                Visibility(
                                  visible: _editing ? false : true,
                                  child: IconButton(
                                    icon: Icon(Icons.edit_outlined),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SubCategoryList();
                                          }).whenComplete(() {
                                        setState(() {
                                          _subCategoryTextController.text =
                                              _provider.selectedSubCategory;
                                        });
                                      });
                                    },
                                  ),
                                )
                              ],
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
                          Row(
                            children: [
                              Text('Stock : '),
                              Expanded(
                                child: TextFormField(
                                  controller: _stockTextController,
                                  style: TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Low Stock : '),
                              Expanded(
                                child: TextFormField(
                                  controller: _lowStockTextController,
                                  style: TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Tax % :'),
                              Expanded(
                                child: TextFormField(
                                  controller: _taxTextController,
                                  style: TextStyle(color: Colors.grey),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
